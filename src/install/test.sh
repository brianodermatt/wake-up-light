sudo bash -c "cat >/boot/config_test.txt" <<'EOF'
# Disable the ACT LED on the Pi Zero.
dtparam=act_led_trigger=none
dtparam=act_led_activelow=on
EOF
