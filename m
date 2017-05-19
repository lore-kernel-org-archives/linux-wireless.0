Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35265 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752916AbdESP7n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 11:59:43 -0400
Received: by mail-oi0-f66.google.com with SMTP id m17so13044245oik.2
        for <linux-wireless@vger.kernel.org>; Fri, 19 May 2017 08:59:42 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/10] rtlwifi: btcoex: More updates for 23b 1ant
Date: Fri, 19 May 2017 10:59:27 -0500
Message-Id: <20170519155937.17526-1-Larry.Finger@lwfinger.net> (sfid-20170519_175947_010894_3F1CD0E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set is the second for file halbtc8723b1ant.c.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Ping-Ke Shih (10):
  rtlwifi: btcoex: 23b 1ant: Switch antenna to wifi or BT.
  rtlwifi: btcoex: 23b 1ant: need these information when scan
  rtlwifi: btcoex: 23b 1ant: adjust wifi duration for bt a2dp
  rtlwifi: btcoex: 23b 1ant: add wifi_only argument to init_hwconfig
  rtlwifi: btcoex: 23b 1ant: Add power_on_setting
  rtlwifi: btcoex: 23b 1ant: parse more BT information from C2H
  rtlwifi: btcoex: 23b 1ant: Setup register for BT WHCK test
  rtlwifi: btcoex: 23b 1ant: Add rf status notification
  rtlwifi: btcoex: 23b 1ant: fine tune connect notify
  rtlwifi: btcoex: 23b 1ant: Revise media status notify to fix no scan
    result issue

 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 1061 ++++++++++++++------
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |   19 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |    3 +
 3 files changed, 798 insertions(+), 285 deletions(-)

-- 
2.12.0
