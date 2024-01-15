#!/bin/bash

oc adm policy add-scc-to-user restricted -z go-web-app-sa -n test
