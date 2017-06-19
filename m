Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0157.hostedemail.com ([216.40.44.157]:35921 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751689AbdFSUSY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 16:18:24 -0400
From: Joe Perches <joe@perches.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] rtlwifi: Neatening
Date: Mon, 19 Jun 2017 13:18:13 -0700
Message-Id: <cover.1497903396.git.joe@perches.com> (sfid-20170619_222015_580533_8D6767BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches (5):
  rtlwifi: Use temporary ops variable to reduce code size
  rtlwifi: Use temporary variable btc_ops for rtlpriv->btcoexist.btc_ops
  rtlwifi: Add and use convenience macro rtl_btc
  realtek: btcoexist: Make the rtl_btc_ops struct const
  realtek: rtlwifi: drivers: Use the rtl_btc convenience macro

 drivers/net/wireless/realtek/rtlwifi/base.c        |  46 ++--
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |   4 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   2 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        | 189 ++++++++--------
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |   9 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         | 242 +++++++++++----------
 drivers/net/wireless/realtek/rtlwifi/ps.c          |  83 +++----
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |   3 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c   |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |   3 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |  40 ++--
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   9 +-
 15 files changed, 336 insertions(+), 310 deletions(-)

-- 
2.10.0.rc2.1.g053435c
