# Grade Analysis Project

## 📊 Project Overview

This project presents a comprehensive analysis of student academic performance spanning over 15 years of educational data. The analysis explores patterns and relationships that influence academic success across multiple departments, courses, and semesters.

### 🎯 Key Objectives
- Analyze student performance patterns across different departments and courses
- Investigate the relationship between attendance and academic success
- Examine temporal trends in academic performance
- Identify factors that contribute to student success in higher education

## 📁 Project Structure

```
grade_analysis/
├── README.md                           # This file
├── FinalCode.R          # Main R analysis script
├── final_project.Rmd                   # R Markdown report
├── final_project.html                  # Generated HTML report
├── install.R                           # Package installation script
├── DESCRIPTION                         # R project metadata
├── LICENSE                             # MIT License
├── .gitignore                          # Git ignore rules
├── .gitattributes                      # Git configuration
└── visualizations/                     # Generated visualizations
    ├── numerical_distributions.pdf     # Distribution plots
    └── variable_relationships.pdf      # Relationship analysis plots
```

**Note**: The `grades.csv` dataset is not included in this repository due to privacy concerns. Users will need to provide their own dataset with the same structure.

## 🚀 Getting Started

### Prerequisites
- R (version 4.0 or higher)
- RStudio (recommended)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repository-url>
   cd grade_analysis
   ```

2. **Install required R packages**
   ```r
   source("install.R")
   ```
   This will automatically install all necessary packages:
   - `colorspace` - For color palettes
   - `ggplot2` - For data visualization
   - `dplyr` - For data manipulation
   - `rmarkdown` - For report generation
   - `knitr` - For dynamic report generation

3. **Prepare your dataset**
   - Create a CSV file named `grades.csv` in the project directory
   - Ensure it has the required column structure (see Data Overview section)
   - The file should contain student performance data with the specified variables

## 📋 Data Overview

### Dataset Information
- **Size**: 1,419 student records (example dataset)
- **Time Span**: 15 years of academic data
- **Variables**: 8 columns including performance metrics and demographic information

### Required Dataset Structure
Your dataset should be named `grades.csv` and contain the following columns:
- `Year`: Academic year (e.g., 2010-2024)
- `Semester`: Fall/Spring semester
- `Department`: Academic department
- `CourseCode`: Course identifier
- `Midterm`: Midterm exam scores (0-100)
- `Final`: Final exam scores (0-100)
- `Attendance`: Attendance rate (0-1)
- `LetterGrade`: Final letter grade (A+ to F)

### Dataset Format
- CSV format with comma separation
- First row should contain column headers
- Missing values can be represented as NA or empty cells

## 🔧 Data Processing

### Missing Values Strategy
- **Midterm/Final Scores**: Replaced with course-semester means
- **Attendance**: Replaced with course medians
- **Letter Grades**: Rows with missing grades were removed

### Score Normalization
- Implemented z-score normalization for Midterm and Final scores
- Normalization performed within each course-semester group
- Ensures fair comparisons across different courses and grading standards

### Grade Conversion
- Letter grades converted to numeric GPA scale (0.0-4.0)
- Supports quantitative analysis and modeling

## 📈 Analysis Features

### 1. Exploratory Data Analysis
- Distribution analysis of all variables
- Department-level performance comparisons
- Temporal trend analysis across years

### 2. Visualization
- **Distribution Plots**: Histograms showing performance patterns by department, year, and semester
- **Relationship Analysis**: Correlation plots and scatter diagrams
- **Interactive HTML Report**: Complete analysis with embedded visualizations

### 3. Key Insights
- Performance patterns across different academic departments
- Relationship between attendance and final grades
- Temporal trends in academic performance
- Course-specific grading patterns

## 📊 Running the Analysis

### Option 1: Run the Complete Analysis
```r
source("FinalCode.R")
```

### Option 2: Generate the HTML Report
```r
rmarkdown::render("final_project.Rmd")
```

### Option 3: View the Pre-generated Report
Open `final_project.html` in your web browser to view the complete analysis.

## 📁 File Descriptions

| File | Description |
|------|-------------|
| `FinalCode.R` | Main analysis script with all data processing and visualization code |
| `final_project.Rmd` | R Markdown document for generating the HTML report |
| `final_project.html` | Pre-generated HTML report with complete analysis |
| `install.R` | Script to install and load required R packages |
| `visualizations/` | Directory containing generated PDF visualizations |
| `grades.csv` | **Not included** - Users must provide their own dataset with the same structure |

## 🎨 Visualizations

The project generates two main visualization files:

1. **`numerical_distributions.pdf`**: Shows distribution patterns of:
   - Midterm performance by department
   - Final exam scores across years
   - Grade distribution by semester
   - Attendance patterns across courses

2. **`variable_relationships.pdf`**: Displays correlation analysis and relationship plots between key variables

## 🔍 Key Findings

### Academic Performance Patterns
- Significant variation in performance across departments
- Clear temporal trends in academic achievement
- Strong correlation between attendance and final grades

### Data Quality Insights
- Missing value patterns across different variables
- Course-specific grading standards
- Semester-based performance variations

## 🤝 Contributing

To contribute to this project:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**Elif Beyza Asan**
- Academic Data Analysis Project
- ADA403 Course Final Project

## 📞 Contact

For questions or suggestions about this analysis, please open an issue in the repository.

---

**Note**: This project is designed for educational purposes and demonstrates comprehensive data analysis techniques using R. The original dataset contained student performance data spanning multiple academic years, but is not included in this repository due to privacy concerns. Users should provide their own dataset with the same structure for analysis. 