Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:36568 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdBAVJT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 16:09:19 -0500
Received: by mail-ot0-f193.google.com with SMTP id 36so46776571otx.3
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2017 13:09:18 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/7] Make changes in debugging in btcoexist
Date: Wed,  1 Feb 2017 15:08:50 -0600
Message-Id: <20170201210857.26516-1-Larry.Finger@lwfinger.net> (sfid-20170201_220926_034323_1ED0E824)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These changes convert the various files in btcoexist to use the same
debugging macros as the rest of the parts of the drivers. In addition,
one typo is fixed in rtl8821ae.

This is all material for 4.11.

Larry


Larry Finger (7):
  rtlwifi: rtl8821ae: Fix typo in symbol for bandwidth numbers
  rtlwifi: btcoexist: Convert halbtc8192e2ant.c to use standard
    debugging
  rtlwifi: btcoexist: Convert halbtc8723b1ant.c to use standard
    debugging
  rtlwifi: btcoexist: Convert halbtc8723b2ant.c to use standard
    debugging
  rtlwifi: btcoexist: Convert halbtc8821a1ant.c to use standard
    debugging
  rtlwifi: btcoexist: Convert halbtc8821a2ant.c to use standard
    debugging
  rtlwifi: btcoexist: Convert halbtcoutsrc.c to use standard debugging

 .../wireless/realtek/rtlwifi/btcoexist/Makefile    |    7 +-
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    |  237 +++--
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |  827 ++++++++-------
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |  973 +++++++++---------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    |  898 +++++++++--------
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 1055 +++++++++++---------
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |    4 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |   12 -
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |   10 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |    8 +-
 10 files changed, 2163 insertions(+), 1868 deletions(-)

-- 
2.10.2
