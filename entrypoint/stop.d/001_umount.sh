#!/bin/bash
umount -f "$(mount | grep "^s3fs" | cut -d' ' -f3)" || true
