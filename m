Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33820 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbdFEPaD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 11:30:03 -0400
Received: by mail-oi0-f68.google.com with SMTP id d99so10783051oic.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jun 2017 08:30:03 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 0/9] rtlwifi: btcoex: Further updates
Date: Mon,  5 Jun 2017 10:29:50 -0500
Message-Id: <20170605152959.27439-1-Larry.Finger@lwfinger.net> (sfid-20170605_173036_568901_B368C47A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of 9 patches contain the material that was originally sent as
1 of 7. Each of these now accomplish a single task.

Larry

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Yan-Hsuan Chuang (9):
  rtlwifi: btcoex: add macros to check chip type
  rtlwifi: btcoex: rename ex_halbtcXXXXYZant to ex_btcXXXXYZant
  rtlwifi: btcoex: settings before firmware is downloaded
  rtlwifi: btcoex: hook external PnP notify by chip for wifi driver
  rtlwifi: btcoex: add settings before the hardware is ready
  rtlwifi: btcoex: hook external functions for newer chips
  rtlwifi: btcoex: bind BT coex information with wifi driver
  rtlwifi: btcoex: remove unused display functions
  rtlwifi: btcoex: let btcoex get wifi rssi and link status

 .../realtek/rtlwifi/btcoexist/halbt_precomp.h      |  22 +
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    |   2 +-
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |  32 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |  52 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  41 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   3 +
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |  38 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |  26 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 838 ++++++++++++++++-----
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  42 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  35 +-
 11 files changed, 814 insertions(+), 317 deletions(-)

-- 
2.13.0
