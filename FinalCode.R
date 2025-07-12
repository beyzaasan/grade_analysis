########################################################
### LOAD DATA AND EXPLORE
########################################################

# Load the dataset
grades <- read.csv("grades.csv", as.is = TRUE)

dim(grades)
names(grades)

head(grades) # Display first few rows
summary(grades) # Summary statistics
str(grades) # Structure of the data

# Removing row numbers column (unique numbers)
if (names(grades)[1] == "X" || names(grades)[1] == "") {
     grades <- grades[, -1]
}

########################################################
### HANDLE MISSING VALUES
########################################################

# Print number of missing values per column
print("Missing values per column:")
print(colSums(is.na(grades)))

# Strategy for handling missing values:
# 1. For Midterm/Final: Replace with mean of same course & semester
# 2. For Attendance: Replace with median of same course
# 3. For LetterGrade: Remove rows (as this is our target variable)

# Handle missing Letter Grades first (remove rows)
grades <- grades[!is.na(grades$LetterGrade), ]

# Function to fill missing values by group
fill_missing <- function(x, group_cols) {
     groups <- do.call(paste, c(group_cols, sep = "_"))
     ave(x, groups, FUN = function(x) {
          x[is.na(x)] <- mean(x, na.rm = TRUE)
          return(x)
     })
}

# Fill missing Midterm scores
grades$Midterm <- fill_missing(
     grades$Midterm,
     list(grades$CourseCode, grades$Semester)
)

# Fill missing Final scores
grades$Final <- fill_missing(
     grades$Final,
     list(grades$CourseCode, grades$Semester)
)

# Fill missing Attendance with course medians
grades$Attendance <- ave(grades$Attendance, grades$CourseCode,
     FUN = function(x) {
          x[is.na(x)] <- median(x, na.rm = TRUE)
          return(x)
     }
)

########################################################
### NORMALIZE SCORES
########################################################

# Function to calculate z-scores by group
normalize_by_group <- function(x, group_cols) {
     groups <- do.call(paste, c(group_cols, sep = "_"))
     ave(x, groups, FUN = function(x) {
          (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
     })
}

# Normalize Midterm and Final scores within each course & semester
# This accounts for different grading scales across courses/semesters
grades$Midterm_norm <- normalize_by_group(
     grades$Midterm,
     list(grades$CourseCode, grades$Semester)
)
grades$Final_norm <- normalize_by_group(
     grades$Final,
     list(grades$CourseCode, grades$Semester)
)

# We keep Attendance as is (not normalized) because:
# 1. It's already on a consistent 0-1 scale
# 2. Absolute values are meaningful (e.g., 80% attendance)
# 3. We want to preserve the actual attendance patterns

########################################################
### LETTER GRADES TO NUMERIC
########################################################

# Convert letter grades to numeric values
grades$numeric_grade <- NA # Initialize new column
grades$numeric_grade[grades$LetterGrade == "A+"] <- 4.0
grades$numeric_grade[grades$LetterGrade == "A"] <- 4.0
grades$numeric_grade[grades$LetterGrade == "A-"] <- 3.7
grades$numeric_grade[grades$LetterGrade == "B+"] <- 3.3
grades$numeric_grade[grades$LetterGrade == "B"] <- 3.0
grades$numeric_grade[grades$LetterGrade == "B-"] <- 2.7
grades$numeric_grade[grades$LetterGrade == "C+"] <- 2.3
grades$numeric_grade[grades$LetterGrade == "C"] <- 2.0
grades$numeric_grade[grades$LetterGrade == "C-"] <- 1.7
grades$numeric_grade[grades$LetterGrade == "D+"] <- 1.3
grades$numeric_grade[grades$LetterGrade == "D"] <- 1.0
grades$numeric_grade[grades$LetterGrade == "F"] <- 0.0
grades$numeric_grade[grades$LetterGrade == "FX"] <- 0.0
grades$numeric_grade[grades$LetterGrade == "FZ"] <- 0.0

# Remove the original letter grade column
grades <- grades[, !(names(grades) %in% "LetterGrade")]

# Rename the new numeric grade column
names(grades)[names(grades) == "numeric_grade"] <- "LetterGrade"

# Check the new column
head(grades)

########################################################
### EXPLORING VARIABLE DISTRIBUTIONS
########################################################

# Load required package
library(colorspace)

# First, let's look at the basic structure of our data
print("Summary of Categorical Variables:")
print("Number of Departments:")
print(table(grades$Department))
print("\nNumber of Unique Courses:")
print(table(grades$CourseCode))
print("\nDistribution across Years:")
print(table(grades$Year))
print("\nDistribution across Semesters:")
print(table(grades$Semester))

# Create directory for visualizations if it doesn't exist
dir.create("visualizations", showWarnings = FALSE, recursive = TRUE)

# Create PDF for visualizing distributions
pdf("visualizations/numerical_distributions.pdf", width = 12, height = 8)
par(mfrow = c(2, 2))

# Create color palettes
dept_colors <- qualitative_hcl(length(unique(grades$Department)))
names(dept_colors) <- unique(grades$Department)


hist(grades$Midterm_norm,
     main = "Midterm Performance by Department\nShowing Department-Level Variations",
     xlab = "Normalized Midterm Score (z-score)",
     breaks = 20,
     col = dept_colors[grades$Department],
     border = "white"
)
legend("topright",
     legend = names(dept_colors),
     fill = dept_colors, cex = 0.7
)

# Histogram of Final Exam Scores Across Years
year_colors <- sequential_hcl(length(unique(grades$Year)))
names(year_colors) <- sort(unique(grades$Year))
hist(grades$Final_norm,
     main = "Final Exam Scores Across Years\nShowing Academic Progress",
     xlab = "Normalized Final Score (z-score)",
     breaks = 20,
     col = year_colors[as.character(grades$Year)],
     border = "white"
)
legend("topright",
     legend = names(year_colors),
     fill = year_colors, cex = 0.7, title = "Year"
)

# Histogram of Grade Distribution by Semester
sem_colors <- qualitative_hcl(length(unique(grades$Semester)))
names(sem_colors) <- unique(grades$Semester)
hist(grades$LetterGrade,
     main = "Grade Distribution by Semester\nRevealing Grading Patterns",
     xlab = "Grade Points",
     breaks = 10,
     col = sem_colors[grades$Semester],
     border = "white"
)
legend("topright",
     legend = names(sem_colors),
     fill = sem_colors, cex = 0.7
)

# Histogram of Attendance Patterns Across Courses
course_colors <- qualitative_hcl(length(unique(grades$CourseCode)))
names(course_colors) <- unique(grades$CourseCode)
hist(grades$Attendance,
     main = "Attendance Patterns Across Courses\nHighlighting Student Engagement",
     xlab = "Attendance Rate",
     breaks = 15,
     col = course_colors[grades$CourseCode],
     border = "white"
)
legend("topright",
     legend = names(course_colors),
     fill = course_colors, cex = 0.7
)

# Additional insights
print("\nKey Findings:")
print("1. Department-wise Performance:")
print(tapply(grades$Midterm_norm, grades$Department, mean, na.rm = TRUE))
print("\n2. Year-over-Year Progress:")
print(tapply(grades$Final_norm, grades$Year, mean, na.rm = TRUE))
print("\n3. Semester Grade Averages:")
print(tapply(grades$LetterGrade, grades$Semester, mean, na.rm = TRUE))
print("\n4. Course Attendance Patterns:")
print(tapply(grades$Attendance, grades$CourseCode, mean, na.rm = TRUE))

dev.off()

########################################################
### EXPLORING RELATIONSHIPS BETWEEN VARIABLES
########################################################

# Create correlation matrix for numerical variables
numerical_vars <- grades[, c("Midterm_norm", "Final_norm", "Attendance", "LetterGrade")]
correlation_matrix <- cor(numerical_vars, use = "complete.obs")
print("Correlation Matrix:")
print(correlation_matrix)

# Create scatter plots to visualize relationships
pdf("visualizations/variable_relationships.pdf", width = 15, height = 10)

# Set up 2x3 plotting area
par(mfrow = c(2, 3))

# Create color scales based on attendance
att_colors <- sequential_hcl(10, palette = "Viridis")
att_breaks <- cut(grades$Attendance, breaks = 10, labels = FALSE)

# Midterm vs Final (colored by Attendance)
plot(grades$Midterm_norm, grades$Final_norm,
     main = "Normalized Midterm vs\nFinal Scores",
     xlab = "Normalized Midterm Score",
     ylab = "Normalized Final Score",
     pch = 19,
     col = att_colors[att_breaks],
     cex = grades$Attendance
)
legend("topright",
     title = "Attendance Rate",
     legend = round(seq(min(grades$Attendance, na.rm = TRUE),
          max(grades$Attendance, na.rm = TRUE),
          length.out = 5
     ), 2),
     col = att_colors[seq(1, 10, length.out = 5)],
     pch = 19
)

# Midterm vs Attendance (colored by Department)
plot(grades$Midterm_norm, grades$Attendance,
     main = "Normalized Midterm vs\nAttendance",
     xlab = "Normalized Midterm Score",
     ylab = "Attendance Rate",
     pch = 19,
     col = dept_colors[grades$Department],
     cex = grades$LetterGrade / 2
)
legend("topleft",
     legend = names(dept_colors),
     col = dept_colors, pch = 19, cex = 0.7
)

# Final vs Attendance (colored by Year)
plot(grades$Final_norm, grades$Attendance,
     main = "Normalized Final vs Attendance",
     xlab = "Normalized Final Score",
     ylab = "Attendance Rate",
     pch = 19,
     col = year_colors[as.character(grades$Year)],
     cex = grades$LetterGrade / 2
)
legend("topleft",
     legend = names(year_colors),
     col = year_colors, pch = 19, cex = 0.7
)

# Midterm vs Letter Grade (colored by Course)
plot(grades$Midterm_norm, grades$LetterGrade,
     main = "Normalized Midterm vs Letter Grade",
     xlab = "Normalized Midterm Score",
     ylab = "Letter Grade",
     pch = 19,
     col = course_colors[grades$CourseCode],
     cex = grades$Attendance
)
legend("topleft",
     legend = names(course_colors),
     col = course_colors, pch = 19, cex = 0.7
)

# Final vs Letter Grade (colored by Semester)
plot(grades$Final_norm, grades$LetterGrade,
     main = "Normalized Final vs Letter Grade",
     xlab = "Normalized Final Score",
     ylab = "Letter Grade",
     pch = 19,
     col = sem_colors[grades$Semester],
     cex = grades$Attendance
)
legend("topleft",
     legend = names(sem_colors),
     col = sem_colors, pch = 19, cex = 0.7
)

# Attendance vs Letter Grade (colored by Department)
plot(grades$Attendance, grades$LetterGrade,
     main = "Attendance vs Letter Grade",
     xlab = "Attendance Rate",
     ylab = "Letter Grade",
     pch = 19,
     col = dept_colors[grades$Department],
     cex = sqrt(grades$Final_norm - min(grades$Final_norm, na.rm = TRUE) + 1)
)
legend("topleft",
     legend = names(dept_colors),
     col = dept_colors, pch = 19, cex = 0.7
)

# Close PDF
dev.off()

########################################################
### SUMMARY STATISTICS
########################################################

# Overall statistics
print("--- Overall Statistics ---")
print(paste("Total students analyzed:", nrow(grades)))
print(paste("Years covered:", min(grades$Year), "to", max(grades$Year)))
print(paste("Number of departments:", length(unique(grades$Department))))
print(paste("Number of courses:", length(unique(grades$CourseCode))))

# Key findings
print("\n=== KEY FINDINGS ===")
print(paste("Overall average GPA:", round(mean(grades$LetterGrade, na.rm = TRUE), 3)))
print(paste("Overall average attendance:", round(mean(grades$Attendance, na.rm = TRUE), 3)))

# Correlation analysis
print("--- Correlation Analysis ---")
strongest_corr <- which(abs(correlation_matrix) == max(abs(correlation_matrix[correlation_matrix != 1])), arr.ind = TRUE)
print(paste(
     "Strongest correlation:",
     rownames(correlation_matrix)[strongest_corr[1]], "vs",
     colnames(correlation_matrix)[strongest_corr[2]],
     "=", round(correlation_matrix[strongest_corr], 3)
))

# Department performance
print("--- Department Performance ---")
dept_performance <- tapply(grades$LetterGrade, grades$Department, mean, na.rm = TRUE)
best_dept <- names(which.max(dept_performance))
worst_dept <- names(which.min(dept_performance))
print(paste("Highest performing department:", best_dept, "with GPA", round(dept_performance[best_dept], 3)))
print(paste("Lowest performing department:", worst_dept, "with GPA", round(dept_performance[worst_dept], 3)))

print("--- Analysis Complete ---")
