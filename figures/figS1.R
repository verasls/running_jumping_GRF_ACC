# Load packages and functions ---------------------------------------------

library(here)
library(tidyverse)
library(ragg)
library(patchwork)

# Load data ---------------------------------------------------------------

load(here("data", "mechanical_load_data.rda"))
mechanical_load_data <- mechanical_load_data |>
  mutate(
    acc_placement = recode_factor(
      acc_placement,
      hip = "Hip",
      lower_back = "Lower back",
      ankle = "Ankle"
    )
  )

# GRF boxplot -------------------------------------------------------------

boxplot_GRF_ver <- mechanical_load_data |>
  filter(acc_placement == "Lower back" & vector == "vertical") |>
  ggplot(aes(x = jump, y = pGRF_BW)) +
  geom_boxplot() +
  scale_y_continuous(
    limits = c(0, 7),
    expand = c(0, 0),
    breaks = seq(0, 7, 1)
  ) +
  theme_light() +
  theme(
    axis.text.y = element_text(size = 13),
    axis.title.y = element_text(size = 16)
  ) +
  labs(x = "", y = "pGRF (BW)")

# ACC boxplots ------------------------------------------------------------

boxplot_ACC_ver <- mechanical_load_data |>
  filter(vector == "vertical") |>
  ggplot(aes(x = jump, y = pACC_g)) +
  geom_boxplot(aes(fill = acc_placement), outlier.size = 0.8) +
  scale_fill_manual(values = c("gray90", "gray70", "gray50")) +
  scale_y_continuous(
    limits = c(0, 14),
    expand = c(0, 0),
    breaks = seq(0, 14, 2)
  ) +
  theme_light() +
  theme(
    axis.text.y = element_text(size = 13),
    axis.title.y = element_text(size = 16),
    legend.title = element_blank()
  ) +
  labs(x = "", y = quote("pACC" ~ (italic(g))))

# LR boxplot --------------------------------------------------------------

boxplot_LR_ver <- mechanical_load_data |>
  filter(acc_placement == "Lower back" & vector == "vertical") |>
  ggplot(aes(x = jump, y = pLR_BWs)) +
  geom_boxplot() +
  scale_y_continuous(
    limits = c(0, 350),
    expand = c(0, 0),
    breaks = seq(0, 350, 50)
  ) +
  theme_light() +
  theme(
    axis.text.x = element_text(size = 13, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 13),
    axis.title.y = element_text(size = 16)
  ) +
  labs(x = "", y = quote("pLR" ~ (N %.% s^-1)))

# AR boxplots -------------------------------------------------------------

boxplot_AR_ver <- mechanical_load_data |>
  filter(vector == "vertical") |>
  ggplot(aes(x = jump, y = pAR_gs)) +
  geom_boxplot(aes(fill = acc_placement), outlier.size = 0.8) +
  scale_fill_manual(values = c("gray90", "gray70", "gray50")) +
  scale_y_continuous(
    limits = c(0, 700),
    expand = c(0, 0),
    breaks = seq(0, 700, 100)
  ) +
  theme_light() +
  theme(
    axis.text.x = element_text(size = 13, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 13),
    axis.title.y = element_text(size = 16),
    legend.title = element_blank(),
  ) +
  labs(x = "", y = quote("pAR" ~ (italic(g) %.% s^-1)))

# Combine and save plots --------------------------------------------------

figS1 <- boxplot_GRF_ver + theme(axis.text.x = element_blank()) +
  boxplot_ACC_ver + theme(axis.text.x = element_blank()) +
  boxplot_LR_ver +
  boxplot_AR_ver +
  plot_annotation(tag_levels = "A") +
  plot_layout(guides = "collect") &
  theme(
    legend.position = "right",
    plot.tag = element_text(size = 17)
  )

agg_png(
  here("figures", "figS1.png"),
  width = 90,
  height = 80,
  units = "cm",
  res = 100,
  scaling = 2
)
plot(figS1)
dev.off()
