Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35139 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764354AbdEYRsU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2017 13:48:20 -0400
Received: by mail-oi0-f65.google.com with SMTP id m17so38647117oik.2
        for <linux-wireless@vger.kernel.org>; Thu, 25 May 2017 10:48:19 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 0/7] rtlwifi: btcoex: Final round of fixes
Date: Thu, 25 May 2017 12:48:07 -0500
Message-Id: <20170525174814.25005-1-Larry.Finger@lwfinger.net> (sfid-20170525_194901_724075_BE6EB6F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These 7 patches finish this round of fixes for the various components
of btcoex.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Larry Finger (3):
  rtlwifi: btcoex: Fix Sparse messages for undeclared symbols
  rtlwifi: btcoex: Fix logic error in 21a 1ant
  rtlwifi: btcoex: Fix another edit mistake in 21a 1ant

Yan-Hsuan Chuang (4):
  rtlwifi: btcoex: update new btcoex version
  rtlwifi: btcoex: fix compiler warnings for unused functions
  rtlwifi: btcoex: bind bt to the adapter when initialization
  rtlwifi: btcoex: 92e: rename function that was missing to be
    consistent

 .../realtek/rtlwifi/btcoexist/halbt_precomp.h      |  22 +
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    |   2 +-
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |  32 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |  53 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  41 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |   1 +
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   3 +
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    |  62 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |  38 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |  26 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 764 +++++++++++++++------
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  43 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  36 +-
 14 files changed, 747 insertions(+), 379 deletions(-)

-- 
2.12.0
