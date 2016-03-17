Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33400 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966640AbcCQSlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 14:41:11 -0400
Received: by mail-oi0-f66.google.com with SMTP id e22so1373172oib.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 11:41:10 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/9] Fix Smatch warnings in rtlwifi family of drivers
Date: Thu, 17 Mar 2016 13:40:55 -0500
Message-Id: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160317_194115_186859_F5431CB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Today's patch by Arndt Bergman showing an indentation problem in rtl8821ae
told me that it was time for rechecking all the code for indentation and
other problems. Along with Arndt's patch, there are no remaining Smatch
warnings.

As with all other cleanup patches, these have low priority.

Larry
---

Larry Finger (9):
  rtlwifi: Fix Smatch warnings
  rtlwifi: btcoexist: Fix Smatch warning
  rtlwifi: rtl8188ee: Fix Smatch warnings
  rtlwifi: rtl8192c-common: Fix Smatch warning
  rtlwifi: rtl8192ee: Fix Smatch warning
  rtlwifi: rtl8192se: Fix Smatch warning
  rtlwifi: rtl8723ae: Fix Smatch warning
  rtlwifi: rtl8723be: Fix Smatch warnings
  rtlwifi: rtl8821ae: Fix Smatch warning

 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |  2 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         | 39 +++++++++++-----------
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   |  3 +-
 .../wireless/realtek/rtlwifi/rtl8192c/dm_common.c  |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/phy.c   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c   |  6 ++--
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   | 10 +++---
 .../net/wireless/realtek/rtlwifi/rtl8723be/rf.c    |  4 +--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    |  6 ++--
 11 files changed, 37 insertions(+), 41 deletions(-)

-- 
2.1.4

