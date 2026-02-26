# RNA-seq Differential Expression Analysis Pipeline
# Author: Raymond Gasembe

# Load libraries
library(tidyverse)
library(pheatmap)

# ---------------------------
# 1. Load Data
# ---------------------------
data <- read.csv("data/example_counts.csv", row.names = 1)

# Preview data
print("Raw Count Data:")
print(data)

# ---------------------------
# 2. Normalize Data
# ---------------------------
# Log2 transformation for normalization
norm_data <- log2(data + 1)

# ---------------------------
# 3. Calculate Fold Change
# ---------------------------
# Compare Sample3 vs Sample1
fold_change <- norm_data$Sample3 - norm_data$Sample1

# ---------------------------
# 4. Create Results Table
# ---------------------------
results <- data.frame(
  Gene = rownames(norm_data),
  FoldChange = fold_change
)

# Save results
write.csv(results, "results/differential_expression_results.csv",
          row.names = FALSE)

# ---------------------------
# 5. Volcano Plot
# ---------------------------
results$Significant <- abs(results$FoldChange) > 1

png("figures/volcano_plot.png")
ggplot(results, aes(x = FoldChange, y = -log10(abs(FoldChange)+0.01),
                    color = Significant)) +
  geom_point() +
  theme_minimal() +
  ggtitle("Volcano Plot of Differential Expression")
dev.off()

# ---------------------------
# 6. Heatmap Visualization
# ---------------------------
png("figures/heatmap.png")
pheatmap(norm_data,
         main = "Gene Expression Heatmap",
         cluster_rows = TRUE,
         cluster_cols = TRUE)
dev.off()

print("Analysis complete. Results saved.")
