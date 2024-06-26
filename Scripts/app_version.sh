#!/bin/bash

xcodebuild -scheme GovUK-Onboarding -showBuildSettings | grep MARKETING_VERSION | tr -d 'MARKETING_VERSION ='
