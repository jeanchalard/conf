#CONF static which yt-dlp
ytd() {
  yt-dlp --add-headers 'sec-ch-ua-platform: "Linux"' --add-headers 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36' --add-headers 'sec-ch-ua: "Chromium";v="130", "Google Chrome";v="130", "Not?A_Brand";v="99"' --add-headers 'DNT: 1' --add-headers 'sec-ch-ua-mobile: ?0' $@ -f 'all' --ignore-config --no-playlist --newline
}
