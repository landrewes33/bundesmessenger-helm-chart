#!/usr/bin/env python3
"""
Final comprehensive translation script for all remaining German text
"""
import re

def translate_file():
    with open('values.yaml', 'r', encoding='utf-8') as f:
        lines = f.readlines()

    # Define all translation patterns
    patterns = [
        # Complete comment lines - more specific patterns first
        (r"  # \(string\) Repository/Image Konfiguration, für Synapse und Workernodes\.",
         "  # (string) Repository/Image configuration for Synapse and worker nodes."),
        (r"  # ursprünglich: \"repository: matrixdotorg/synapse\"",
         "  # originally: \"repository: matrixdotorg/synapse\""),
        (r"  # \(list\) Optional kann ein Array von imagePullSecrets angegeben werden\.",
         "  # (list) Optionally an array of imagePullSecrets can be specified."),
        (r"  # Secrets müssen manuell im Namensraum angelegt werden\.",
         "  # Secrets must be created manually in the namespace."),
        (r"  # \(string\) Pullpolicy für das konfigurierte Image",
         "  # (string) Pull policy for the configured image"),

        # Word-level replacements in comments
        (r" für ", " for "),
        (r" und ", " and "),
        (r" mit ", " with "),
        (r" oder ", " or "),
        (r" nicht ", " not "),
        (r" wenn ", " if "),
        (r" als ", " as "),
        (r" vom ", " from "),
        (r" zur ", " for "),
        (r" zum ", " to "),
        (r" beim ", " when "),
        (r" nach ", " after "),
        (r" bei ", " at "),
        (r" über ", " via "),
        (r" unter ", " under "),
        (r" aus ", " from "),
        (r" auf ", " on "),
        (r" an ", " to "),
        (r" in ", " in "),
        (r" von ", " of "),
        (r" zu ", " to "),
        (r" dem ", " the "),
        (r" den ", " the "),
        (r" der ", " the "),
        (r" die ", " the "),
        (r" das ", " the "),
        (r" des ", " of the "),
        (r" ein ", " a "),
        (r" eine ", " a "),
        (r" eines ", " of a "),
        (r" einem ", " a "),
        (r" einen ", " a "),
        (r" einer ", " a "),
        (r" wird ", " is "),
        (r" werden ", " are "),
        (r" kann ", " can "),
        (r" können ", " can "),
        (r" sollte ", " should "),
        (r" sollten ", " should "),
        (r" muss ", " must "),
        (r" müssen ", " must "),
        (r" ist ", " is "),
        (r" sind ", " are "),
        (r" hat ", " has "),
        (r" haben ", " have "),
        (r" wurde ", " was "),
        (r" wurden ", " were "),

        # Common nouns
        (r" Nutzer", " user"),
        (r" Nutzung", " usage"),
        (r" Konfiguration", " configuration"),
        (r" Einstellungen", " settings"),
        (r" Verweis", " reference"),
        (r" Angabe", " specification"),
        (r" Beispiel", " example"),
        (r" Hinweis", " note"),
        (r" Achtung", " warning"),
        (r" Warnung", " warning"),
    ]

    translated_lines = []
    for line in lines:
        # Only translate comment lines (starting with  #)
        if line.strip().startswith('#'):
            for pattern, replacement in patterns:
                line = re.sub(pattern, replacement, line)
        translated_lines.append(line)

    with open('values.yaml', 'w', encoding='utf-8') as f:
        f.writelines(translated_lines)

    print("Translation complete!")

if __name__ == "__main__":
    translate_file()
