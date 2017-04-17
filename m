Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34133 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751894AbdDQAHF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:07:05 -0400
Received: by mail-oi0-f65.google.com with SMTP id t14so15960169oif.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:07:04 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/13] rtlwifi: btcoex: Second set of 21a 1ant changes
Date: Sun, 16 Apr 2017 19:06:47 -0500
Message-Id: <20170417000700.29057-1-Larry.Finger@lwfinger.net> (sfid-20170417_020722_536008_CBD2C2BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches finishes the changes for btcoexist/halbtc8821a1ant.c.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Yan-Hsuan Chuang (13):
  rtlwifi: btcoex: 21a 1ant: set tdma and coex table when wifi is idle
  rtlwifi: btcoex: 21a 1ant: more bt profiling when wifi receives
    special packet
  rtlwifi: btcoex: 21a 1ant: shorten wifi slot when connected scan
  rtlwifi: btcoex: 21a 1ant: react to special packet when wifi is not
    scanning
  rtlwifi: btcoex: 21a 1ant: coex table and tdma settings for softap
    mode
  rtlwifi: btcoex: 21a 1ant: wifi slot time adjustment
  rtlwifi: btcoex: 21a 1ant: normal mode for retry limit when connected
  rtlwifi: btcoex: 21a 1ant: mark packet high priority when scanning
  rtlwifi: btcoex: 21a 1ant: use default value when initiating coex
  rtlwifi: btcoex: 21a 1ant: re-init coex after wifi leaves IPS
  rtlwifi: btcoex: 21a 1ant: treat ARP as special packet
  rtlwifi: btcoex: 21a 1ant: fix some coding style issues
  rtlwifi: btcoex: 21a 1ant: add bt_tx_rx_mask into bt info

 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 257 +++++++++++++++------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |   2 +
 2 files changed, 186 insertions(+), 73 deletions(-)

-- 
2.12.0
