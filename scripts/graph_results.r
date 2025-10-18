#------------------------------------------------------------------------------------------#
####                               Performance graphs                                   ####
#                                                                                          #
#                   Aitor Vázquez Veloso, 09/06/2023 (original paper)                      #
#                   1st modification: 20/01/2025 (short communication)                     #
#                   Last modification: 17/10/2025 (short communication)                    #
#------------------------------------------------------------------------------------------#


#### Basic steps ####

library(tidyverse)
library(reshape2) # change structure of data
library(ggplot2)
library(ggdist)
library(ggpubr)
library(grid)
library(ROCR)

setwd('/media/aitor/WDE/PhD_UVa/1_Topics/2.2_Vitality_short/')



#### Load general information ####

# load support functions
source('2_scripts/8.1_functions_performance_graphs.r')

# load the variables groups from the previous code
load('1_data/case_study_summary.RData')

# filter just the example case study
case_study <- case_study[case_study$name == 'Tcontrol_Vextreme', ]  

# df to compare the best model among study cases
all_cases_best_model_compilation <- tibble()

# Loading the workspace
load(paste('1_data/', case_study$name, '/final_metrics.RData', sep = ''))

# common information
n_data <- length(my_combis)
names_methods <- c('LR', 'DT', 'RF', 'NB', 'KNN', 'SVM')  #, 'ANN')
color_methods <- c('gray', 'darkolivegreen', 'darkgreen', 'darkblue', 'darkred', 'darkorange')  #, 'gold')
names_metrics <- c('ACC', 'ACCa', 'ACCd', 'AUC', 'AUCPR', 'K', 'MCC')
color_metrics <- c('green', 'darkolivegreen', 'darkgreen', 'darkblue', 'darkviolet', 'darkorange', 'gold2')

# KAPPA data extraction
lr_k2 = 0
for(k in 1:n_data){
  lr_k2[[k]] <- lr_kappa[[k]]$value
}

# MCC data extraction
lr_mcc2 = 0
for(k in 1:n_data){
  lr_mcc2[[k]] <- lr_mcc[[k]][[2]]
}

# create a list of metrics
metric_list <- list(lr_accuracy, lr_accuracy_alive, lr_accuracy_dead, lr_auc, lr_aucpr, lr_k2, lr_mcc2)

# create df to store metrics
all_models_metrics <- as.data.frame(matrix(nrow = n_data, ncol = 0))

# for each value on the list
for(k in 1:length(metric_list)){
  
  # store values on the main df    
  all_models_metrics <- cbind(all_models_metrics, data.frame(matrix(unlist(metric_list[k]))))
  colnames(all_models_metrics)[k] = names_metrics[k]
}

# add the model code on the df
all_models_metrics$model_code <- c(1:n_data)

# change shape of data
# all_models_metrics$status <- 1 # content doesn't matter now
all_models_metrics <- melt(all_models_metrics, id.var="model_code")



# Graph one: metrics for 180 candidate models on LR ====

# Create a ggplot with only density plots
ggplot(all_models_metrics, aes(x = value, colour = variable)) + 
  geom_density(lwd = 1, linetype = 1) + 
  labs(#title = 'LR performance on 180 candidate models',
       x = 'Performance level', y = 'Number of models') +  
  theme_light() + 
  theme(text = element_text(family = "Times New Roman"),
        plot.title = element_text(size = 20, hjust = 0.5),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        legend.text = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.position = c(0.08, 0.8)) +  # relative position according to the graph area
  scale_color_manual(name = "Metric", values = color_metrics) 
  
# save graph
ggsave(filename = '3_output/LR_performance_distribution.jpg', device = 'jpeg', units = 'mm', 
       dpi = 300, width = 160, height = 106)



# Graph two: best model selected according to each metric ====

# filter the best model based on each metric
best_model_by_metric <- all_models_metrics %>%
  group_by(variable) %>%
  slice_max(value, with_ties = FALSE) %>%
  ungroup()

# Create a ggplot with only density plots
ggplot(best_model_by_metric, aes(x = variable, y = value, fill = variable)) + 
  geom_bar(stat = "identity", show.legend = FALSE) +  
  geom_text(aes(label = paste('model ', model_code, sep = '')), vjust = -0.5, size = 4, fontface = "italic") +
  labs(#title = 'Best LR model based on each metric', 
       x = 'Metric', y = 'Performance level') +  
  theme_light() + 
  theme(text = element_text(family = "Times New Roman"),
        plot.title = element_text(size = 20, hjust = 0.5),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        plot.tag = element_text(size = 18),
        plot.tag.location = 'margin') +  # panel, plot or margin
  scale_fill_manual(name = "Metric", values = color_metrics) + 
  labs(tag = 'A')

# save graph
ggsave(filename = '3_output/LR_best_model_by_metric.jpg', device = 'jpeg', units = 'mm', 
       dpi = 300, width = 160, height = 106)


# Create a ggplot with only density plots
ggplot(best_model_by_metric, aes(x = variable, y = value, fill = variable)) + 
  geom_bar(stat = "identity", show.legend = FALSE) +  
  geom_text(aes(label = paste('model ', model_code, sep = '')), vjust = -0.5, size = 4, fontface = "italic") +
  labs(#title = 'Best LR model based on each metric', 
    x = 'Metric', y = 'Performance level') +  
  theme_light() + 
  theme(text = element_text(family = "Times New Roman"),
        plot.title = element_text(size = 20, hjust = 0.5),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        plot.tag = element_text(size = 18),
        plot.tag.location = 'margin') +  # panel, plot or margin
  scale_fill_manual(name = "Metric", values = color_metrics) #+ 
  # labs(tag = 'A')

# save graph
ggsave(filename = '3_output/LR_best_model_by_metric-no_label.jpg', device = 'jpeg', units = 'mm', 
       dpi = 300, width = 160, height = 106)




# Graph three: metrics for best model on LR based on MCC ====

# filter the best model based on MCC
mcc_for_lr <- all_models_metrics[all_models_metrics$variable == 'MCC', ] 
best_mcc_value <- max(mcc_for_lr$value)
best_mcc_model <- mcc_for_lr[mcc_for_lr$value == best_mcc_value, ]

# filter the best model for all metrics
best_mcc_model_metrics <- all_models_metrics[all_models_metrics$model_code == best_mcc_model$model_code, ]

# Create a ggplot with only density plots
ggplot(best_mcc_model_metrics, aes(x = variable, y = value, fill = variable)) + 
  geom_bar(stat = "identity", show.legend = FALSE) +  
  labs(#title = 'Best LR model performance based on MCC', 
    x = 'Metric', y = 'Performance level') +  
  theme_light() + 
  theme(text = element_text(family = "Times New Roman"),
        plot.title = element_text(size = 20, hjust = 0.5),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        plot.tag = element_text(size = 18),
        plot.tag.location = 'margin') + # panel, plot or margin
  scale_fill_manual(name = "Metric", values = color_metrics) + 
  labs(tag = 'B')

# save graph
ggsave(filename = '3_output/LR_best_mcc_model.jpg', device = 'jpeg', units = 'mm', 
       dpi = 300, width = 160, height = 106)



# Graph four: comparison between model 14 and model 176 (best for ACCd and MCC, respectively) ====

models_14_and_176_metrics <- all_models_metrics[all_models_metrics$model_code %in% c(14, 176), ]

ggplot(models_14_and_176_metrics, aes(x = variable, y = value, fill = as.factor(model_code))) + 
  geom_bar(stat = "identity", position = position_dodge(), show.legend = TRUE) +  
  labs(#title = 'Best LR model performance based on MCC', 
    x = 'Metric', y = 'Performance level') +  
  theme_light() + 
  theme(text = element_text(family = "Times New Roman"),
        plot.title = element_text(size = 20, hjust = 0.5),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        plot.tag = element_text(size = 18),
        plot.tag.location = 'margin',  # panel, plot or margin
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 12),
        legend.position = c(0.9, 0.8)) +  # relative position according to the graph area
  scale_fill_manual(name = "Model code", values = c("darkolivegreen", "gold2")) +
  labs(tag = 'C')

ggsave(filename = '3_output/LR_model_14_vs_176.jpg', device = 'jpeg', units = 'mm', 
       dpi = 300, width = 160, height = 106)



# Graph five: comparison between best models by metric ====

best_model_on_one_metric <- all_models_metrics[all_models_metrics$model_code %in% best_model_by_metric$model_code, ]
color_metrics_reordered <- c('darkgreen', 'darkorange', 'darkblue', 'darkolivegreen', 'darkviolet', 'green', 'gold2')
best_model_on_one_metric$variable <- factor(best_model_on_one_metric$variable, levels = names_metrics)

ggplot(best_model_on_one_metric, aes(x = variable, y = value, colour = as.factor(model_code))) + 
  geom_point(size = 2.5) +
  labs(#title = 'Best model by metric comparison, 
    x = 'Metric', y = 'Performance level') +  
  theme_light() + 
  theme(text = element_text(family = "Times New Roman"),
        plot.title = element_text(size = 20, hjust = 0.5),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        plot.tag = element_text(size = 18),
        plot.tag.location = 'margin',  # panel, plot or margin
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 12),
        legend.position = c(0.88, 0.8)) +  # relative position according to the graph area
  scale_colour_manual(name = "Model code", values = color_metrics_reordered, 
                      labels = c('14 (ACCd)', '72 (K)', '86 (AUC)', '94 (ACCa)', '146 (AUCPR)', 
                                 '156 (ACC)', '176 (MCC)')) +
  labs(tag = 'B')

ggsave(filename = '3_output/LR_best_model_on_one_metric.jpg', 
       device = 'jpeg', units = 'mm', dpi = 300, width = 160, height = 106)

# graph without label
ggplot(best_model_on_one_metric, aes(x = variable, y = value, colour = as.factor(model_code))) + 
  geom_point(size = 2.5) +
  labs(#title = 'Best model by metric comparison, 
    x = 'Metric', y = 'Performance level') +  
  theme_light() + 
  theme(text = element_text(family = "Times New Roman"),
        plot.title = element_text(size = 20, hjust = 0.5),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        plot.tag = element_text(size = 18),
        plot.tag.location = 'margin',  # panel, plot or margin
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 12),
        legend.position = c(0.88, 0.8)) +  # relative position according to the graph area
  scale_colour_manual(name = "Model code", values = color_metrics_reordered, 
                      labels = c('14 (ACCd)', '72 (K)', '86 (AUC)', '94 (ACCa)', '146 (AUCPR)', 
                                 '156 (ACC)', '176 (MCC)')) 
  # labs(tag = 'B')

ggsave(filename = '3_output/LR_best_model_on_one_metric-no_label.jpg', 
       device = 'jpeg', units = 'mm', dpi = 300, width = 160, height = 106)


# Graph six: all models on all algorithms all metrics ====

# General accuracy
all_methods_acc <- list(lr_accuracy, dt_accuracy, rf_accuracy, nb_accuracy, 
                        knn_accuracy, svm_accuracy)  #, ann_accuracy)
best_accuracy <- find_best_model(names_methods = names_methods, # methods names
                                 all_methods_acc = all_methods_acc, # list with all the metrics of each method
                                 my_combis = my_combis) # features combinations

# Alive trees accuracy
all_methods_acc_alive <- list(lr_accuracy_alive, dt_accuracy_alive, rf_accuracy_alive, 
                              nb_accuracy_alive, knn_accuracy_alive, svm_accuracy_alive)  #, ann_accuracy_alive)
best_accuracy_alive <- find_best_model(names_methods = names_methods, # methods names
                                       all_methods_acc = all_methods_acc_alive, # list with all the metrics of each method
                                       my_combis = my_combis) # features combinations

# Dead trees accuracy
all_methods_acc_dead <- list(lr_accuracy_dead, dt_accuracy_dead, rf_accuracy_dead, 
                             nb_accuracy_dead, knn_accuracy_dead, svm_accuracy_dead)  #, ann_accuracy_dead)
best_accuracy_dead <- find_best_model(names_methods = names_methods, # methods names
                                      all_methods_acc = all_methods_acc_dead, # list with all the metrics of each method
                                      my_combis = my_combis) # features combinations

# AUC
all_methods_auc <- list(lr_auc, dt_auc, rf_auc, nb_auc, 
                        knn_auc, svm_auc)  #, ann_auc)
best_auc <- find_best_model(names_methods = names_methods, # methods names
                            all_methods_acc = all_methods_auc, # list with all the metrics of each method
                            my_combis = my_combis) # features combinations

# AUCPR
all_methods_aucpr <- list(lr_aucpr, dt_aucpr, rf_aucpr, nb_aucpr, 
                          knn_aucpr, svm_aucpr)  #, ann_aucpr)
best_aucpr <- find_best_model(names_methods = names_methods, # methods names
                              all_methods_acc = all_methods_aucpr, # list with all the metrics of each method
                              my_combis = my_combis) # features combinations

# KAPPA
all_methods_kappa <- all_methods_acc
for(k in 1:length(my_combis)){
  all_methods_kappa[[1]][k] <- ifelse(lr_kappa[[k]]$value != 'NaN', lr_kappa[[k]]$value, 0)
  all_methods_kappa[[2]][k] <- ifelse(dt_kappa[[k]]$value != 'NaN', dt_kappa[[k]]$value, 0)
  all_methods_kappa[[3]][k] <- ifelse(rf_kappa[[k]]$value != 'NaN', rf_kappa[[k]]$value, 0)
  all_methods_kappa[[4]][k] <- ifelse(nb_kappa[[k]]$value != 'NaN', nb_kappa[[k]]$value, 0)
  all_methods_kappa[[5]][k] <- ifelse(knn_kappa[[k]]$value != 'NaN', knn_kappa[[k]]$value, 0)
  all_methods_kappa[[6]][k] <- ifelse(svm_kappa[[k]]$value != 'NaN', svm_kappa[[k]]$value, 0)
  #all_methods_kappa[[7]][k] <- ifelse(ann_kappa[[k]]$value != 'NaN', ann_kappa[[k]]$value, 0)
}
best_kappa <- find_best_model(names_methods = names_methods, # methods names
                              all_methods_acc = all_methods_kappa, # list with all the metrics of each method
                              my_combis = my_combis) # features combinations

# MCC
all_methods_mcc <- all_methods_acc
for(k in 1:length(my_combis)){
  all_methods_mcc[[1]][k] <- ifelse(lr_mcc[[k]][2] != 'NaN', lr_mcc[[k]][2], 0)
  all_methods_mcc[[2]][k] <- ifelse(dt_mcc[[k]][2] != 'NaN', dt_mcc[[k]][2], 0)
  all_methods_mcc[[3]][k] <- ifelse(rf_mcc[[k]][2] != 'NaN', rf_mcc[[k]][2], 0)
  all_methods_mcc[[4]][k] <- ifelse(nb_mcc[[k]][2] != 'NaN', nb_mcc[[k]][2], 0)
  all_methods_mcc[[5]][k] <- ifelse(knn_mcc[[k]][2] != 'NaN', knn_mcc[[k]][2], 0)
  all_methods_mcc[[6]][k] <- ifelse(svm_mcc[[k]][2] != 'NaN', svm_mcc[[k]][2], 0)
  #all_methods_mcc[[7]][k] <- ifelse(ann_mcc[[k]][2] != 'NaN', ann_mcc[[k]][2], 0)
}
best_mcc <- find_best_model(names_methods = names_methods, # methods names
                            all_methods_acc = all_methods_mcc, # list with all the metrics of each method
                            my_combis = my_combis) # features combinations

# Step 1: Combine the list of lists into a data frame
# Function to transform a list of lists into a data frame
transform_list_to_df <- function(data_list, algorithm_names, metric) {
  
  # Check if the number of method names matches the number of elements in the data list
  if (length(algorithm_names) != length(data_list)) {
    stop("The length of 'method_names' must match the length of 'data_list'.")
  }
  
  # Loop through the list and convert each element into a data frame
  transformed_data <- lapply(seq_along(data_list), function(i) {
    data <- unlist(data_list[[i]])  # Flatten inner list
    data.frame(algorithm = algorithm_names[i], value = data)
    })
  
  # Combine all data frames into one
  combined_data <- dplyr::bind_rows(transformed_data)
  
  # save names
  combined_data$names <- rownames(combined_data)
  
  # save metric name
  combined_data$metric <- metric
  
  return(combined_data)
}

# get df for each list and group all of them
all_acc <- transform_list_to_df(all_methods_acc, names_methods, 'ACC')
all_acca <- transform_list_to_df(all_methods_acc_alive, names_methods, 'ACCa')
all_accd <- transform_list_to_df(all_methods_acc_dead, names_methods, 'ACCd')
all_auc <- transform_list_to_df(all_methods_auc, names_methods, 'AUC')
all_aucpr <- transform_list_to_df(all_methods_aucpr, names_methods, 'AUCPR')
all_kappa <- transform_list_to_df(all_methods_kappa, names_methods, 'K')
all_mcc <- transform_list_to_df(all_methods_mcc, names_methods, 'MCC')
all_data <- rbind(all_acc, all_acca, all_accd, all_auc, all_aucpr, all_kappa, all_mcc)

# reorder
all_data$algorithm <- factor(all_data$algorithm, levels = names_methods)

# Step 2: Create the violin plot
ggplot(all_data, aes(x = algorithm, y = value, fill = algorithm)) +
  geom_violin(trim = FALSE) +  # Add violin plots
  labs(
    title = "Performance of 180 candidate models for each metric and algorithm",
    x = "Algorithm",
    y = "Performance"
  ) +
  theme_minimal() +  # Apply a minimal theme
  theme(text = element_text(family = "Times New Roman"),
        plot.title = element_text(hjust = 0.5), legend.position = "none") +  # Center title, remove legend
  scale_fill_manual(values = color_methods) + 
  facet_wrap(~metric)

# save graph
ggsave(filename = '3_output/all_algorithms_models_and_metrics.jpg', 
       device = 'jpeg', units = 'mm', dpi = 300, width = 160, height = 106, bg = 'white')

# alternative density graph
ggplot(all_data, aes(x = value, colour = algorithm)) + 
  geom_density(lwd = 1, linetype = 1) + 
  labs(#title = 'LR performance on 180 candidate models',
    x = 'Performance level', y = 'Number of models') +  
  theme_light() + 
  theme(text = element_text(family = "Times New Roman"),
        plot.title = element_text(size = 20, hjust = 0.5),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        legend.text = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.position = c(0.9, 0.15),
        strip.text = element_text(size = 12)) +  # relative position according to the graph area
  scale_color_manual(name = "Algorithm", values = color_methods) +
  facet_wrap(~metric) 


#--> density graph looking better

# create individual subsets
data1 <- subset(all_data, metric %in% c("ACC", "ACCa", "ACCd"))
data2 <- subset(all_data, metric %in% c("AUC", "AUCPR"))
data3 <- subset(all_data, metric %in% c("K", "MCC"))

# create separate plots
plot1 <- ggplot(data1, aes(x = value, colour = algorithm)) +
  geom_density(lwd = 0.75, linetype = 1) +
  labs(x = NULL, y = NULL) +
  theme_light() +
  xlim(0, 1) +
  theme(text = element_text(family = "Times New Roman"),
        axis.text.x = element_text(size = 8),
        axis.text.y = element_text(size = 8),
        legend.text = element_text(size = 8),
        legend.title = element_text(size = 8),
        strip.text = element_text(size = 8)) +
  scale_color_manual(name = "Algorithm  ", values = color_methods) +
  facet_wrap(~metric, ncol = 3, scales = "free_x")

plot2 <- ggplot(data2, aes(x = value, colour = algorithm)) +
  geom_density(lwd = 0.75, linetype = 1) +
  labs(x = NULL, y = NULL) +
  theme_light() +
  theme(text = element_text(family = "Times New Roman"),
        axis.text.x = element_text(size = 8),
        axis.text.y = element_text(size = 8),
        legend.text = element_text(size = 8),
        legend.title = element_text(size = 8),
        strip.text = element_text(size = 8)) +
  xlim(0, 1) +
  scale_color_manual(name = "Algorithm  ", values = color_methods) +
  
  facet_wrap(~metric, ncol = 2)

plot3 <- ggplot(data3, aes(x = value, colour = algorithm)) +
  geom_density(lwd = 0.75, linetype = 1) +
  labs(x = NULL, y = NULL) +
  theme_light() +
  theme(text = element_text(family = "Times New Roman"),
        axis.text.x = element_text(size = 8),
        axis.text.y = element_text(size = 8),
        legend.text = element_text(size = 8),
        legend.title = element_text(size = 8),
        strip.text = element_text(size = 8)) +
  xlim(0, 1) +
  scale_color_manual(name = "Algorithm  ", values = color_methods) +
  facet_wrap(~metric, ncol = 2)

# combine all plots
combined_plot <- ggarrange(plot1, plot2, plot3,
                           ncol = 1, common.legend = TRUE, legend = "right")

# add shared axis labels
annotate_figure(
  combined_plot,
  bottom = text_grob("Performance level", size = 10),
  left = text_grob("Number of models", size = 10, rot = 90)
)

ggsave(filename = '3_output/density_all_algorithms_models_and_metrics.jpg', 
       device = 'jpeg', units = 'mm', dpi = 300, width = 160, height = 106, bg = 'white')




# Graph seven: best model of each algorithm based on the best metric value for each metric ====

# group df and plot again
best_accuracy$Metrics <- 'ACC'
best_accuracy_alive$Metrics <- 'ACCa'
best_accuracy_dead$Metrics <- 'ACCd'
best_auc$Metrics <- 'AUC'
best_aucpr$Metrics <- 'AUCPR'
best_kappa$Metrics <- 'K'
best_mcc$Metrics <- 'MCC'
best_compilation <- rbind(best_accuracy, best_accuracy_alive, best_accuracy_dead,
                          best_auc, best_aucpr, best_kappa, best_mcc)

# set the name of the case study
best_compilation$case <- case_study$name[case]

# reorder
best_compilation$names_methods <- factor(best_compilation$names_methods, 
                                         levels = names_methods)

ggplot(best_compilation, aes(x = names_methods, y = as.numeric(best_acc), fill = Metrics)) + 
  geom_bar(stat = "identity", position = 'dodge', ) +
  geom_text(aes(label = best_model), position = position_dodge(width = 0.9), 
            vjust = 0.3, hjust = -0.1, size = 2.5, angle = 90, fontface = "italic") +
  theme_light() +
  theme_light() + 
  theme(text = element_text(family = "Times New Roman"),
        plot.title = element_text(size = 20, hjust = 0.5),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10),
        plot.tag = element_text(size = 15),
        legend.text = element_text(size = 10),
        legend.title = element_text(size = 10),
        plot.tag.location = 'margin') +  # panel, plot or margin
  labs(#title = 'Metrics comparison for the best model of each algorithm',
       x = 'Algorithm', y = 'Performance level') + 
  scale_fill_manual(name = 'Metrics', values = color_metrics) + 
  labs(tag = 'A')

# save graph
ggsave(filename = '3_output/best_model_per_algorithm_for_each_metric.jpg', device = 'jpeg', units = 'mm', 
       dpi = 300, width = 160, height = 106)

# repeat the graph without label
ggplot(best_compilation, aes(x = names_methods, y = as.numeric(best_acc), fill = Metrics)) + 
  geom_bar(stat = "identity", position = 'dodge', ) +
  geom_text(aes(label = best_model), position = position_dodge(width = 0.9), 
            vjust = 0.3, hjust = -0.1, size = 2.5, angle = 90, fontface = "italic") +
  theme_light() +
  theme_light() + 
  theme(text = element_text(family = "Times New Roman"),
        plot.title = element_text(size = 20, hjust = 0.5),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10),
        plot.tag = element_text(size = 15),
        legend.text = element_text(size = 10),
        legend.title = element_text(size = 10),
        plot.tag.location = 'margin') +  # panel, plot or margin
  labs(#title = 'Metrics comparison for the best model of each algorithm',
    x = 'Algorithm', y = 'Performance level') + 
  scale_fill_manual(name = 'Metrics', values = color_metrics) #+ 
  # labs(tag = 'A')

# save graph
ggsave(filename = '3_output/best_model_per_algorithm_for_each_metric-no_label.jpg', device = 'jpeg', units = 'mm', 
       dpi = 300, width = 160, height = 106)



# Graph eight: comparison between best model per algorithm by metric ====

# function to group all the metrics that select the same best model
get_metrics_groups <- function(df) {
grouped_df <- df %>%
  # Extract the numeric part of the "code" column
  mutate(numeric_code = str_extract(code, "\\d+")) %>%
  # Group by the numeric part
  group_by(numeric_code) %>%
  # Summarize the bracketed content
  summarise(
    grouped_brackets = paste0(str_extract_all(code, "(?<=\\().*?(?=\\))") %>% unlist(), collapse = ", "),
    .groups = "drop"  # Drop grouping if you don't need it later
  )
return(grouped_df)
}


# filter the desired models
lr_best_compilation <- best_compilation[best_compilation$names_methods == 'LR', ]
lr_best_compilation$model_code <- paste('lr_model_', lr_best_compilation$best_model, sep = '')
lr_models <- all_data %>%
  filter(algorithm == "LR", names %in% c(lr_best_compilation$model_code))
lr_models$model_code <- gsub('lr_model_', '', lr_models$names)

lr_best_compilation$code <- paste(lr_best_compilation$best_model, ' (', 
                                  lr_best_compilation$Metrics, ')', sep = '')
lr_groups <- get_metrics_groups(lr_best_compilation)
lr_best_compilation$best_model <- as.character(lr_best_compilation$best_model)
lr_best_compilation <- merge(lr_best_compilation, lr_groups, 
                             by.x = "best_model", by.y = "numeric_code")
lr_best_compilation$label <- paste(lr_best_compilation$best_model, ' (', 
                                   lr_best_compilation$grouped_brackets, ')', sep = '')

lr_best_compilation <- select(lr_best_compilation, best_model, label)
lr_models <- merge(lr_models, lr_best_compilation, by.x = 'model_code', by.y = 'best_model')


dt_best_compilation <- best_compilation[best_compilation$names_methods == 'DT', ]
dt_best_compilation$model_code <- paste('dt_model_', dt_best_compilation$best_model, sep = '')
dt_models <- all_data %>%
  filter(algorithm == "DT", names %in% c(dt_best_compilation$model_code))
dt_models$model_code <- gsub('dt_model_', '', dt_models$names)

dt_best_compilation$code <- paste(dt_best_compilation$best_model, ' (', 
                                  dt_best_compilation$Metrics, ')', sep = '')
dt_groups <- get_metrics_groups(dt_best_compilation)
dt_best_compilation$best_model <- as.character(dt_best_compilation$best_model)
dt_best_compilation <- merge(dt_best_compilation, dt_groups, 
                             by.x = "best_model", by.y = "numeric_code")
dt_best_compilation$label <- paste(dt_best_compilation$best_model, ' (', 
                                   dt_best_compilation$grouped_brackets, ')', sep = '')

dt_best_compilation <- select(dt_best_compilation, best_model, label)
dt_models <- merge(dt_models, dt_best_compilation, by.x = 'model_code', by.y = 'best_model')


rf_best_compilation <- best_compilation[best_compilation$names_methods == 'RF', ]
rf_best_compilation$model_code <- paste('rf_model_', rf_best_compilation$best_model, sep = '')
rf_models <- all_data %>%
  filter(algorithm == "RF", names %in% c(rf_best_compilation$model_code))
rf_models$model_code <- gsub('rf_model_', '', rf_models$names)

rf_best_compilation$code <- paste(rf_best_compilation$best_model, ' (', 
                                  rf_best_compilation$Metrics, ')', sep = '')
rf_groups <- get_metrics_groups(rf_best_compilation)
rf_best_compilation$best_model <- as.character(rf_best_compilation$best_model)
rf_best_compilation <- merge(rf_best_compilation, rf_groups, 
                             by.x = "best_model", by.y = "numeric_code")
rf_best_compilation$label <- paste(rf_best_compilation$best_model, ' (', 
                                   rf_best_compilation$grouped_brackets, ')', sep = '')

rf_best_compilation <- select(rf_best_compilation, best_model, label)
rf_models <- merge(rf_models, rf_best_compilation, by.x = 'model_code', by.y = 'best_model')


nb_best_compilation <- best_compilation[best_compilation$names_methods == 'NB', ]
nb_best_compilation$model_code <- paste('nb_model_', nb_best_compilation$best_model, sep = '')
nb_models <- all_data %>%
  filter(algorithm == "NB", names %in% c(nb_best_compilation$model_code))
nb_models$model_code <- gsub('nb_model_', '', nb_models$names)

nb_best_compilation$code <- paste(nb_best_compilation$best_model, ' (', 
                                  nb_best_compilation$Metrics, ')', sep = '')
nb_groups <- get_metrics_groups(nb_best_compilation)
nb_best_compilation$best_model <- as.character(nb_best_compilation$best_model)
nb_best_compilation <- merge(nb_best_compilation, nb_groups, 
                             by.x = "best_model", by.y = "numeric_code")
nb_best_compilation$label <- paste(nb_best_compilation$best_model, ' (', 
                                   nb_best_compilation$grouped_brackets, ')', sep = '')

nb_best_compilation <- select(nb_best_compilation, best_model, label)
nb_models <- merge(nb_models, nb_best_compilation, by.x = 'model_code', by.y = 'best_model')


knn_best_compilation <- best_compilation[best_compilation$names_methods == 'KNN', ]
knn_best_compilation$model_code <- paste('knn_model_', knn_best_compilation$best_model, sep = '')
knn_models <- all_data %>%
  filter(algorithm == "KNN", names %in% c(knn_best_compilation$model_code))
knn_models$model_code <- gsub('knn_model_', '', knn_models$names)

knn_best_compilation$code <- paste(knn_best_compilation$best_model, ' (', 
                                   knn_best_compilation$Metrics, ')', sep = '')
knn_groups <- get_metrics_groups(knn_best_compilation)
knn_best_compilation$best_model <- as.character(knn_best_compilation$best_model)
knn_best_compilation <- merge(knn_best_compilation, knn_groups, 
                              by.x = "best_model", by.y = "numeric_code")
knn_best_compilation$label <- paste(knn_best_compilation$best_model, ' (', 
                                    knn_best_compilation$grouped_brackets, ')', sep = '')

knn_best_compilation <- select(knn_best_compilation, best_model, label)
knn_models <- merge(knn_models, knn_best_compilation, by.x = 'model_code', by.y = 'best_model')


svm_best_compilation <- best_compilation[best_compilation$names_methods == 'SVM', ]
svm_best_compilation$model_code <- paste('svm_model_', svm_best_compilation$best_model, sep = '')
svm_models <- all_data %>%
  filter(algorithm == "SVM", names %in% c(svm_best_compilation$model_code))
svm_models$model_code <- gsub('svm_model_', '', svm_models$names)

svm_best_compilation$code <- paste(svm_best_compilation$best_model, ' (', 
                                   svm_best_compilation$Metrics, ')', sep = '')
svm_groups <- get_metrics_groups(svm_best_compilation)
svm_best_compilation$best_model <- as.character(svm_best_compilation$best_model)
svm_best_compilation <- merge(svm_best_compilation, svm_groups, 
                              by.x = "best_model", by.y = "numeric_code")
svm_best_compilation$label <- paste(svm_best_compilation$best_model, ' (', 
                                    svm_best_compilation$grouped_brackets, ')', sep = '')

svm_best_compilation <- select(svm_best_compilation, best_model, label)
svm_models <- merge(svm_models, svm_best_compilation, by.x = 'model_code', by.y = 'best_model')


# graph each model separately
graph_eight <- function(df, title = NULL, leg_pos = c(0.02, 0.30)) {
  ggplot(df, aes(x = metric, y = as.numeric(value), colour = as.factor(label))) +
    geom_point(size = 1) +
    labs(title = title, x = NULL, y = NULL) +
    theme_minimal() +
    theme(
      text = element_text(family = "Times New Roman"),
      plot.title = element_text(size = 8, hjust = 0.5),
      axis.text.x = element_text(size = 6),
      axis.text.y = element_text(size = 6),
      
      # ---- LEYENDA DENTRO DEL PANEL, ESQUINA SUP-IZQ ----
      legend.position       = leg_pos,         # coordenadas relativas dentro del panel
      legend.justification  = c(0, 1),               # anclar arriba-izquierda
      legend.background     = element_rect(fill = scales::alpha("white", 0.75),
                                           colour = "grey85"),
      # ---- Título y texto ----
      legend.title = element_text(size = 5),
      legend.text  = element_text(size = 5, lineheight = 0.85),
      
      # ---- Compactación vertical/horizontal ----
      legend.key.height = unit(2.0, "mm"),
      legend.key.width  = unit(3.0, "mm"),
      legend.spacing.y  = unit(0, "mm"),             # espacio entre keys
      legend.margin     = margin(0, 0, 0, 0),
      legend.box.margin = margin(0, 0, 0, 0)
    ) +
    ylim(0, 1) +
    scale_colour_manual(name = "Model code", values = color_metrics) +
    guides(
      colour = guide_legend(
        ncol = 1, byrow = TRUE,                      # una sola columna, apilado compacto
        keyheight = unit(2.0, "mm"), keywidth = unit(3.0, "mm"),
        override.aes = list(size = 1.2)              # puntos más pequeños en la leyenda
      )
    )
}

g_lr <- graph_eight(lr_models, title = 'LR', leg_pos = c(0.6, 0.45))
g_dt <- graph_eight(dt_models, title = 'DT', leg_pos = c(0.5, 0.4))
g_rf <- graph_eight(rf_models, title = 'RF', leg_pos = c(0.35, 0.3))
g_nb <- graph_eight(nb_models, title = 'NB', leg_pos = c(0.05, 0.4))
g_knn <- graph_eight(knn_models, title = 'KNN', leg_pos = c(0.05, 0.4))
g_svm <- graph_eight(svm_models, title = 'SVM', leg_pos = c(0.05, 0.4))

# compile all models
combi_plot <- ggarrange(g_lr, g_dt, g_rf, g_nb, g_knn, g_svm,
                        ncol = 3, nrow = 2,  
                        common.legend = FALSE)

# add shared axis labels
annotate_figure(
  combi_plot,
  bottom = text_grob("Number of models", size = 8),
  left = text_grob("Metric", size = 8, rot = 90)
)

ggsave(filename = '3_output/points_all_algorithms_models_and_metrics.jpg', 
       device = 'jpeg', units = 'mm', dpi = 300, width = 160, height = 106, bg = 'white')






# compile all models
# models_graph_eight <- rbind(lr_models, dt_models, rf_models, nb_models, knn_models, svm_models)
# models_graph_eight$label <- gsub('_MODEL', '', toupper(models_graph_eight$names))
# models_graph_eight$label <- paste(models_graph_eight$label, ' (', models_graph_eight$metric, ')', sep = '')

# ggplot(models_graph_eight, aes(x = metric, y = value, colour = as.factor(names))) + 
#   geom_point(size = 5) +
#   labs(#title = 'Best model by metric comparison, 
#     x = 'Metric', y = 'Performance level') +  
#   theme_light() + 
#   theme(plot.title = element_text(size = 20, face = 'bold', hjust = 0.5),
#         axis.text.x = element_text(size = 16),
#         axis.text.y = element_text(size = 16),
#         axis.title.x = element_text(size = 16, face = 'bold'),
#         axis.title.y = element_text(size = 16, face = 'bold'),
#         plot.tag = element_text(size = 25, face = "bold"),
#         plot.tag.location = 'margin',  # panel, plot or margin
#         legend.text = element_text(size = 20),
#         legend.title = element_text(size = 20, face = 'bold'),
#         legend.position = c(0.9, 0.85)) +  # relative position according to the graph area
#   # scale_colour_manual(name = "Model code", values = color_metrics_reordered, 
#   #                     labels = c('14 (ACCd)', '72 (K)', '86 (AUC)', '94 (ACCa)', '146 (AUCPR)', 
#   #                                '156 (ACC)', '176 (MCC)')) +
#   labs(tag = 'B') + 
#   facet_wrap(~algorithm)
# 
# ggsave(filename = '3_output/LR_best_model_on_one_metric.jpg', 
#        device = 'jpeg', units = 'mm', dpi = 300, width = 160, height = 106)




# Graph nine: best model per algorithm based on MCC ====

# filter the best model of each algorithm based on MCC
mcc_best <- best_compilation[best_compilation$Metrics == 'MCC', ] 
mcc_best$name_to_filter <- paste(tolower(mcc_best$names_methods), '_model_', mcc_best$best_model, sep = '')
all_mcc_best <- all_data[all_data$names %in% mcc_best$name_to_filter, ]

# graph
ggplot(all_mcc_best, aes(x = algorithm, y = as.numeric(value), fill = metric)) + 
  geom_bar(stat = "identity", position = 'dodge') +
  theme_light() +
  theme(text = element_text(family = "Times New Roman"),
        plot.title = element_text(hjust = 0.5)) +
  labs(title = 'Performance of the best model based on MCC per algorithm',
       x = 'Algorithm', y = 'Performance') + 
  scale_fill_manual(name = 'Metrics', values = color_metrics)

# save graph
ggsave(filename = '3_output/best_model_on_mcc.jpg', device = 'jpeg', units = 'mm', dpi = 300, 
       width = 160, height = 106)
