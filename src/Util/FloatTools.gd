class_name FloatTools

# Define the new method
func is_equal_approx(a : float, b : float, epsilon : float = 0.00001) -> bool:
	return abs(a - b) < epsilon
