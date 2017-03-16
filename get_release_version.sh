#!/bin/bash
# I wanted to use `git describe` for this, but some build environments add their own git tags,
# which makes the `git describe` output inconsistent with what the container sees.
echo -n '1.4.35-tagged4sflow1'
