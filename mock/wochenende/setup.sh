# Wochenende setup. Set environment variables for Wochenende https://github.com/MHH-RCUG/Wochenende
# v0.2 2021_06
# Only uncommented lines without a # are read


#############
# Users: change following two paths as appropriate
#############

# Install_directory for Wochenende on your system, full path
wochenende_install_dir=/mnt/ngsnfs/tools/dev/Wochenende

# Install_directory for Haybaler https://github.com/MHH-RCUG/haybaler on your system, full path
haybaler_install_dir=/mnt/ngsnfs/tools/dev/haybaler



# Users: please do not change this.
# add to user .bashrc so they are available in users environment after new login

echo "## Config for the metagenome analyzer Wochenende" >> ~/.bashrc
echo "export WOCHENENDE_DIR=$wochenende_install_dir" >> ~/.bashrc
echo "export HAYBALER_DIR=$haybaler_install_dir" >> ~/.bashrc

# Setup Bash variables
WOCHENENDE_DIR=$wochenende_install_dir
HAYBALER_DIR=$haybaler_install_dir
PARSE_YAML_CMD=$WOCHENENDE_DIR/scripts/parse_yaml.sh

# Make variables from config.yaml available in Bash
echo "source "$PARSE_YAML_CMD >> ~/.bashrc
echo "eval \$(parse_yaml" $WOCHENENDE_DIR"/config.yaml)" >> ~/.bashrc
source  ~/.bashrc
echo "INFO: Added some config to the end of your ~/.bashrc setup file and sourced the file "
echo "INFO: The last 10 lines of your ~/.bashrc file now look like this:"
echo "INFO: ######################## "
echo " "
tail -n 10  ~/.bashrc

echo "INFO: ######################## "
echo " "
echo "INFO: If the paths don't look ok please remove them from ~/.bashrc, correct them in setup.sh, and rerun setup.sh":
echo "INFO: Wochenende setup complete"