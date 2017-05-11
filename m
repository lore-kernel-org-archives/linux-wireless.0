Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:32839 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756572AbdEKXY6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 19:24:58 -0400
Received: by mail-oi0-f65.google.com with SMTP id h4so6462640oib.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 16:24:57 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/10] rtlwifi: btcoex: Part 2 of fixes for halbtc8821a1ant.c
Date: Thu, 11 May 2017 18:24:28 -0500
Message-Id: <20170511232438.23159-1-Larry.Finger@lwfinger.net> (sfid-20170512_012503_119025_DF39775E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches continue the fixes for file halbtc8821a1ant.c. Some
of these patches were previously submitted, but withdrawn.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>


Yan-Hsuan Chuang (10):
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

 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 180 +++++++++++++--------
 1 file changed, 117 insertions(+), 63 deletions(-)

-- 
2.12.2
