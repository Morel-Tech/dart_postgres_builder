#!/bin/sh

mason make github_actions_dart --on-conflict overwrite --exclude 'postgres_builder_example' --minCoverage 100 --flutterVersion '3.13.6' --flutterChannel stable --dartChannel stable --dependabotFrequency monthly --generateDependabot true --generateSemanticPullRequest true --generateSpellCheck true --spellCheckConfig cspell.json --workflowRef main