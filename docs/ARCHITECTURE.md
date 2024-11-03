## Design Documentation: Time-Tracking Application

### Overview
This application is a simple time-tracking tool that allows users to log the current timestamp against a selected project code. The goal is to create an intuitive interface for quick and easy time tracking. Users can enter a new project code or select from previously entered codes. The logged data is stored in a local database and can be exported as a CSV file. 

This application is implemented in **Rust** using the **iced** GUI library, ensuring cross-platform compatibility across Windows, macOS, and Linux.

### Components and Features

#### User Interface (UI)

1. **Text Input with Dropdown for Project Codes**
   - Allows the user to enter a new project code or select a previously used one.
   - The dropdown is populated from previously stored project names in the database.
   - Implemented using `TextInput` and `Dropdown` widgets in `iced`.

2. **Log Button**
   - When clicked, this button captures the current timestamp and saves it along with the selected project code in a local database.
   - Uses `Button` widget from `iced`.

3. **Export Button**
   - Exports all logged data to a CSV file.
   - Located at the bottom of the application window for easy access.
   - Uses `Button` widget from `iced`.

4. **Data Display (Optional)**
   - Optionally, a small display area could show recent logs, giving the user a quick view of recent entries.

#### Functional Components

1. **Database (SQLite)**
   - Stores logged data locally, using an SQLite database via the `rusqlite` crate for simplicity.
   - Table schema:
     - `id` (INTEGER): Primary key, auto-incremented.
     - `project_code` (TEXT): The project code entered by the user.
     - `timestamp` (TEXT): The timestamp when the entry was logged.

2. **Current Timestamp Logging**
   - Upon clicking the "Log" button, the application retrieves the current timestamp, associates it with the selected project code, and stores it in the database.

3. **Export to CSV**
   - When the user clicks the "Export" button, all entries from the database are retrieved and written to a CSV file.
   - File is saved in a user-defined location, with the file name reflecting the current date (e.g., `logs_YYYYMMDD.csv`).

### Application Flow

1. **Startup**
   - The application loads and initializes the database connection.
   - The project codes from previous entries are fetched and loaded into the dropdown list.

2. **Logging an Entry**
   - The user enters or selects a project code and clicks "Log."
   - The current timestamp is recorded along with the project code in the database.

3. **Exporting Data**
   - The user clicks "Export" to save all logs to a CSV file.
   - The application fetches all entries from the database and writes them to a CSV file at the specified location.

### Technical Details

1. **Libraries and Crates**
   - `iced`: Provides the GUI framework.
   - `chrono`: Handles date and time functionality.
   - `rusqlite`: SQLite library for Rust, handling local storage.
   - `csv`: Facilitates CSV file generation during export.

2. **File Structure**
   - **`main.rs`**: Entry point; initializes the iced application.
   - **`database.rs`**: Contains functions for database operations (e.g., connecting, inserting logs, exporting).
   - **`ui.rs`**: Manages UI layout and components.
   - **`export.rs`**: Contains functions for exporting data to a CSV file.

3. **Database Schema**
   ```sql
   CREATE TABLE IF NOT EXISTS logs (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       project_code TEXT NOT NULL,
       timestamp TEXT NOT NULL
   );
   ```

4. **Key Functions**
   - **initialize_database**: Creates the SQLite database and `logs` table if they don’t exist.
   - **log_time(project_code: String)**: Inserts a new entry into the `logs` table with the current timestamp.
   - **fetch_project_codes()**: Retrieves unique project codes for populating the dropdown list.
   - **export_to_csv(file_path: &str)**: Fetches all log entries from the database and writes them to a CSV file.

### UI Implementation in Rust with Iced

Below is a high-level implementation outline using `iced`.

```rust
use iced::{Application, Button, Column, Command, Dropdown, TextInput, Element, Row, Settings, Text};
use chrono::Utc;
use rusqlite::Connection;

struct TimeTrackerApp {
    project_code: String,
    log_button: Button,
    export_button: Button,
    project_dropdown: Dropdown,
    database: Connection,
}

impl Application for TimeTrackerApp {
    fn new() -> (Self, Command<Message>) {
        let database = initialize_database();
        (Self {
            project_code: String::new(),
            log_button: Button::new("Log"),
            export_button: Button::new("Export"),
            project_dropdown: Dropdown::new(fetch_project_codes(&database)),
            database,
        }, Command::none())
    }

    fn update(&mut self, message: Message) -> Command<Message> {
        match message {
            Message::Log => {
                log_time(&self.project_code, &self.database);
            },
            Message::Export => {
                export_to_csv("logs.csv", &self.database);
            },
            Message::ProjectCodeChanged(code) => {
                self.project_code = code;
            },
        }
        Command::none()
    }

    fn view(&self) -> Element<Message> {
        Column::new()
            .push(
                Row::new()
                    .push(TextInput::new("Enter project code...", &self.project_code, Message::ProjectCodeChanged))
                    .push(self.project_dropdown)
            )
            .push(self.log_button)
            .push(self.export_button)
            .into()
    }
}
```

### Error Handling

- **Database Connectivity**: Proper error handling for database connectivity and operations will ensure the application does not crash.
- **File Access**: During export, if the file cannot be created (e.g., permission issues), an error message should be displayed.
- **User Input**: The application should validate project codes (e.g., no special characters) before inserting them into the database.

### Future Improvements

1. **Data Visualization**: Include charts to view time logged for each project over time.
2. **Advanced Export Options**: Allow date-range filtering when exporting logs.
3. **User Authentication**: Add optional user authentication to support multiple users.
