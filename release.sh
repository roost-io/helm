#!/usr/bin/env bash

helm package charts/roost-ai -d docs

helm repo index docs --url https://roost-io.github.io/helm