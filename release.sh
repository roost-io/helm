#!/usr/bin/env bash

helm package charts/roost -d releases

helm repo index releases --url https://roost-io.github.io/helm/releases