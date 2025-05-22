# 🧠 SmartSort - PowerShell Smart File Organizer

**SmartSort** is a PowerShell script that automatically organizes files into subfolders based on their file extensions. It's perfect for cleaning up cluttered folders like `Downloads`, `Documents`, or even your corporate `OneDrive`.

## 🚀 Features

- Detects local and corporate OneDrive folders (e.g., `OneDrive - CompanyName`)
- Categorizes and moves files into organized subfolders
- Automatically creates subfolders if they don’t exist
- Previews all planned actions before execution
- Displays a progress bar during processing
- Supports multiple file categories

## 📁 Supported File Types

| Category        | Extensions                                       |
|----------------|--------------------------------------------------|
| PDF            | `.pdf`                                           |
| Images         | `.jpg`, `.jpeg`, `.png`, `.gif`                  |
| Documents      | `.doc`, `.docx`                                  |
| Text           | `.txt`                                           |
| Spreadsheets   | `.xls`, `.xlsx`, `.csv`                          |
| Videos         | `.mp4`, `.avi`                                   |
| Audio          | `.mp3`, `.wav`                                   |
| Presentations  | `.pptx`, `.odp`                                  |
| Archives       | `.zip`, `.rar`                                   |
| Executables    | `.exe`, `.msi`                                   |
| Data           | `.json`, `.xml`                                  |
| Scripts        | `.ps1`                                           |

## ⚙️ Requirements

- Windows 10 or higher
- PowerShell 5.1+
- Read/write access to the selected folders

## ▶️ How to Use

1. Open PowerShell.
2. Navigate to the folder containing `SmartSort.ps1`.
3. Run the script:
   ```powershell
   .\SmartSort.ps1
4. Choose the base folder (e.g., local or OneDrive).
5. Enter the name of the folder you want to organize (e.g., Downloads).
6. Confirm the organization.

## 📌 Example
Where do you want to organize files?
0 - Local user folder (Downloads, Documents, etc.)
1 - OneDrive - MyCompany
Enter the number of the desired option: 1
Enter the NAME of the folder to organize inside 'C:\Users\John\OneDrive - MyCompany': Downloads

The following files will be moved:
File               Destination
----               -----------
report.pdf         ...\Downloads\PDF
image.jpg          ...\Downloads\Images

Do you want to proceed? (Y/N): Y
Organization completed successfully!

## 📦 Project Structure
📁 smartsort

├── SmartSort.ps1

├── README.md

├── LICENSE

└── .gitignore
