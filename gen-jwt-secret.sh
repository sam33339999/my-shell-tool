#!/bin/bash

# Generate a random string of 32 characters

for i in {1..10}; do
  openssl rand -base64 32
done

for i in {1..10}; do
  openssl rand -hex 32
done

for i in {1..10}; do
  node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"
done


for i in {1..10}; do
  node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
done

