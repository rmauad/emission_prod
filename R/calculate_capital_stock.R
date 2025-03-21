# Function to calculate capital stock using Perpetual Inventory Method
calculate_capital_stock <- function(capital_flow, 
                                    depreciation_rate,
                                    initial_year = NULL,
                                    initial_stock = NULL,
                                    growth_rate) {
  
  # Input validation
  if (!is.numeric(capital_flow)) {
    stop("Capital flow must be a numeric vector")
  }
  
  if (depreciation_rate <= 0 || depreciation_rate >= 1) {
    stop("Depreciation rate must be between 0 and 1")
  }
  
  n <- length(capital_flow)
  capital_stock <- numeric(n)
  
  # Calculate initial capital stock if not provided
  if (is.null(initial_stock)) {
    # Using steady-state approach: K₀ = I₀/(δ + g)
    # where I₀ is initial investment, δ is depreciation rate, g is growth rate
    initial_stock <- capital_flow[1] / (depreciation_rate + growth_rate)
  }
  
  # Initialize first period
  capital_stock[1] <- initial_stock
  
  # Calculate capital stock for subsequent periods
  # K[t] = K[t-1] * (1-δ) + I[t]
  for (t in 2:n) {
    capital_stock[t] <- capital_stock[t-1] * (1 - depreciation_rate) + capital_flow[t]
  }
  
  return(capital_stock)
}
