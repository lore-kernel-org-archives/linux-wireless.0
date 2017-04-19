Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33855 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759193AbdDSCVr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 22:21:47 -0400
Received: by mail-oi0-f66.google.com with SMTP id t14so2125244oif.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Apr 2017 19:21:47 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 0/2] rtlwifi: btcoex: Two more patches
Date: Tue, 18 Apr 2017 21:21:41 -0500
Message-Id: <20170419022143.15484-1-Larry.Finger@lwfinger.net> (sfid-20170419_042153_702805_8E8B8A96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two patches finish the updates to btcoex for the 4.12 streeam.

Larry

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Yan-Hsuan Chuang (2):
  rtlwifi: btcoex: update new btcoex version
  rtlwifi: btcoex: fix compiler warnings for unused functions

 .../realtek/rtlwifi/btcoexist/halbt_precomp.h      |  22 +
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |  32 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |  52 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  41 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   3 +
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |  38 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |  10 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |  28 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 838 ++++++++++++++++-----
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  42 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  35 +-
 11 files changed, 824 insertions(+), 317 deletions(-)

-- 
2.12.0
