*** Settings ***
Library         Browser
Library         Collections
Variables       ../variables/global_vars.py
Variables       ../variables/${ENV.lower()}_vars.py
