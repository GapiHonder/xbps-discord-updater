# xbps-discord-updater
A simple bash script to update Discord from source with xtools

# Discord Package Management Script

This Bash script helps manage the Discord package in Void Linux by allowing users to update its version, execute necessary commands, and install or compile the package from source.

## What does the script do?

The script performs the following actions:

1. **Update Version**: Allows users to update the version of the Discord package by modifying the package template file.
2. **Execute Commands**: Provides options to execute necessary commands such as `xgensum` and `xbps-src pkg`.
3. **Install or Compile**: Allows users to install the Discord package or compile it from source.

## Usage

1. Clone this repository to your local machine:

    ```bash
    git clone https://github.com/your_username/discord-package-updater.git
    ```

2. Navigate to the cloned directory:

    ```bash
    cd discord-package-updater
    ```

3. Make sure you have the required dependencies installed:

    - `git`: Version control system for tracking changes in source code.
    - `dialog`: Used for creating interactive dialogs in the terminal.
    - `sed`: Stream editor for filtering and transforming text.
    - `xbps-src`: Void Linux package builder.
    - `xtools`: Collection of tools for Void Linux package development.

    You can install them on Void Linux using xbps:

    ```bash
    sudo xbps-install -S git dialog sed xbps-src xtools
    ```

4. Make the script executable:

    ```bash
    chmod +x discord_final.sh
    ```

5. Run the script:

    ```bash
    ./discord_final.sh
    ```

6. Follow the on-screen prompts to update the Discord package version, execute necessary commands, and install or compile the package from source.

## Dependencies

- `git`: Version control system for tracking changes in source code.
- `dialog`: Used for creating interactive dialogs in the terminal.
- `sed`: Stream editor for filtering and transforming text.
- `xbps-src`: Void Linux package builder.
- `xtools`: Collection of tools for Void Linux package development.

## When to Use

- Use this script when you need to update the version of the Discord package in Void Linux.
- Use it to execute necessary commands such as `xgensum` and `xbps-src pkg`.
- Use it to install or compile the Discord package from source.

## Contributing

Contributions are welcome! If you have suggestions or find any issues, please feel free to open an issue or create a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
