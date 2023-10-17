#Exchange rates in domestic/USD, 2010 averages

load("df.RData")
COU <- unique(df$COU)
er <- c(1.33,
        +         0.0525833333333333,
        +         1.33,
        +         0.177308333333333,
        +         1.33,
        +         1.33,
        +         1.33,
        +         1.33,
        +         1.55,
        +         1.33,
        +         0.00485,
        +         1.33,
        +         1.33,
        +         1.33,
        +         1.33,
        +         1.33,
        +         1.33,
        +         0.330965550085391,
        +         1.33,
        +         1.33,
        +         0.139410485112965,
        +         1)

fx <- cbind(COU, er)
fx <- as.data.frame(fx)

save(fx, file = "fx.RData")