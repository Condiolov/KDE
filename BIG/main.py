#!/usr/bin/env python3

import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')

from gi.repository import Gtk, Adw
import os
import locale
import gettext
import subprocess

# Set up gettext for application localization
DOMAIN = 'biglinux-settings'
LOCALE_DIR = '/usr/share/locale'

locale.setlocale(locale.LC_ALL, '')
locale.bindtextdomain(DOMAIN, LOCALE_DIR)
locale.textdomain(DOMAIN)

gettext.bindtextdomain(DOMAIN, LOCALE_DIR)
gettext.textdomain(DOMAIN)
_ = gettext.gettext

class BiglinuxSettingsApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id='org.biglinux.biglinux-settings')
        self.connect('activate', self.on_activate)

    def on_activate(self, app):
        self.window = CustomWindow(application=app)
        self.window.present()

class CustomWindow(Adw.ApplicationWindow):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.set_title(_("System Settings"))
        self.set_default_size(600, 800)
        self.switch_scripts = {}
        self.setup_ui()

    def setup_ui(self):
        main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_content(main_box)

        header_bar = Adw.HeaderBar()
        main_box.append(header_bar)

        view_stack = Adw.ViewStack()
        main_box.append(view_stack)

        view_switcher = Adw.ViewSwitcher()
        view_switcher.set_stack(view_stack)
        header_bar.set_title_widget(view_switcher)

        # Define the directory containing script folders
        scripts_dir = "./"  # Replace with actual path
        self.populate_tabs(view_stack, scripts_dir)

    def populate_tabs(self, view_stack, scripts_dir):
        if not os.path.exists(scripts_dir):
            return

        # Get all directories in the scripts_dir
        for folder in sorted(os.listdir(scripts_dir)):
            folder_path = os.path.join(scripts_dir, folder)
            if os.path.isdir(folder_path):
                page = Adw.PreferencesPage()
                group = Adw.PreferencesGroup()
                group.set_title(_(folder.capitalize()))
                page.add(group)
                view_stack.add_titled(page, folder, _(folder.capitalize()))
                self.populate_scripts(folder_path, group)

    def populate_scripts(self, folder_path, group):
        # Get all .sh scripts in the folder
        for script in sorted(os.listdir(folder_path)):
            if script.endswith('.sh'):
                script_path = os.path.join(folder_path, script)
                title, description = self.get_script_info(script_path)
                self.create_switch_row(group, title, description, script_path)

    def get_script_info(self, script_path):
        # Default values
        title = os.path.basename(script_path).replace('.sh', '').capitalize()
        description = ""

        try:
            with open(script_path, 'r') as file:
                for line in file:
                    if line.startswith('# Title:'):
                        title = line.replace('# Title:', '').strip()
                    elif line.startswith('# Description:'):
                        description = line.replace('# Description:', '').strip()
        except Exception as e:
            print(f"Error reading script info {script_path}: {e}")
        return title, description

    def create_switch_row(self, group, title, description, script_path):
        row = Adw.PreferencesRow()
        main_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12, margin_top=6, margin_bottom=6, margin_start=12, margin_end=12)
        row.set_child(main_box)

        title_area = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, hexpand=True)
        main_box.append(title_area)

        title_label = Gtk.Label(xalign=0, label=_(title))
        title_label.add_css_class("title-4")
        title_area.append(title_label)

        if description:
            subtitle_label = Gtk.Label(xalign=0, wrap=True, label=_(description))
            subtitle_label.add_css_class("caption")
            subtitle_label.add_css_class("dim-label")
            title_area.append(subtitle_label)

        switch = Gtk.Switch(valign=Gtk.Align.CENTER)
        main_box.append(switch)

        self.switch_scripts[switch] = script_path
        switch.connect("state-set", self.on_switch_changed)
        self.sync_switch(switch, script_path)

        group.add(row)

    def check_script_state(self, script_path):
        try:
            result = subprocess.run([script_path, "check"], capture_output=True, text=True, timeout=5)
            return result.stdout.strip().lower() == "true"
        except Exception as e:
            print(f"Error checking state {script_path}: {e}")
            return False

    def toggle_script_state(self, script_path, state):
        try:
            state_str = "true" if state else "false"
            result = subprocess.run([script_path, "toggle", state_str], capture_output=True, text=True, timeout=10)
            return result.returncode == 0
        except Exception as e:
            print(f"Error toggling state {script_path}: {e}")
            return False

    def sync_switch(self, switch, script_path):
        state = self.check_script_state(script_path)
        switch.handler_block_by_func(self.on_switch_changed)
        switch.set_active(state)
        switch.handler_unblock_by_func(self.on_switch_changed)

    def on_switch_changed(self, switch, state):
        script_path = self.switch_scripts.get(switch)
        if script_path:
            if not self.toggle_script_state(script_path, state):
                switch.handler_block_by_func(self.on_switch_changed)
                switch.set_active(not state)
                switch.handler_unblock_by_func(self.on_switch_changed)

def main():
    app = BiglinuxSettingsApp()
    return app.run()

if __name__ == "__main__":
    main()