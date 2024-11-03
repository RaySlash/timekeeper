# Time-Tracking Application

This Rust-based time-tracking application lets users log timestamps against project codes and export logs to CSV. Designed for simplicity, the app provides an intuitive interface using the `iced` cross-platform GUI library, making it compatible across Windows, macOS, and Linux.

## Features

- **Log Project Time**: Enter a project code or select a previously used one, then log the current timestamp.
- **Export Logs to CSV**: Export all stored logs to a CSV file with a single click.
- **Persistent Storage**: All logs are stored in a local SQLite database.

## Screenshots

![Time-Tracking App UI](docs/screenshots/main_ui.png)

## Installation

### Prerequisites

- **Rust**: Ensure Rust is installed. You can install it from [rust-lang.org](https://www.rust-lang.org/).
- **SQLite**: This application uses SQLite for local data storage.
- **Nix**: If using the `nix` environment, ensure you have **Nix** and **direnv** installed.

### Setting Up the Development Environment

1. **Clone the Repository**

    ```sh
    git clone https://github.com/yourusername/time-tracking-app.git
    cd time-tracking-app
    ```

2. **Enter Development Environment**

    This project uses **Nix** and **direnv** for a reproducible development environment. To enter the environment:

    - Run `direnv allow` (if `direnv` is initialized in your shell).
    - Alternatively, use `nix develop` to enter the environment manually.

### Building and Running the Project

Once inside the environment, you can build and run the application:

```sh
cargo build --release
cargo run --release
```

## Usage

1. **Log Time**
   - Open the application.
   - Enter a project code in the text box or select an existing code from the dropdown.
   - Click the **Log** button to save the current timestamp against the project.

2. **Export Logs**
   - Click the **Export** button to export all logged data to a CSV file.
   - The CSV file is saved in the application’s directory with the format `logs_YYYYMMDD.csv`.

## File Structure

- **`src/main.rs`**: Application entry point, initializes the GUI.
- **`src/database.rs`**: Database operations for logging and exporting data.
- **`src/ui.rs`**: Manages UI components and layout.
- **`src/export.rs`**: Exports logged data to a CSV file.

## Configuration

No additional configuration is needed. All data is stored in an SQLite database in the project directory (`logs.db` by default).

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature (`git checkout -b feature-branch`).
3. Make your changes and commit (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a Pull Request.

## Dependencies

- **[iced](https://github.com/iced-rs/iced)**: Cross-platform GUI library.
- **[chrono](https://github.com/chronotope/chrono)**: Handles date and time operations.
- **[rusqlite](https://github.com/rusqlite/rusqlite)**: SQLite library for Rust.
- **[csv](https://docs.rs/csv/latest/csv/)**: For generating CSV files.

## Future Improvements

- **Data Visualization**: Visualize logged data with charts.
- **Advanced Export Options**: Export logs for a specific date range.
- **Multi-user Support**: Add user accounts and permissions.

## License

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for more details.
