Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37023 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1ISTea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 15:34:30 -0400
Received: by yie30 with SMTP id 30so4350516yie.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 12:34:30 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] rtlwifi: Miscellaneous cleanups
Date: Mon, 19 Sep 2011 14:34:06 -0500
Message-Id: <1316460850-16443-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110919_213434_075976_7B01E6E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These cleanups consist of changing the messages output by modinfo to make
them easier to understand, and one that combines a macro used by three of
the drivers into a single copy.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is all -next material.

Larry
---

Larry Finger (4):
  rtlwifi: rtl8192ce: Change modinfo messages
  rtlwifi: rtl8192se: Change modinfo messages
  rtlwifi: rtl8192de: Change modinfo messages
  rtlwifi: Combine instances of RTL_HAL_IS_CCK_RATE macros.

 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |   12 ++++++++----
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h |    6 ------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h |    6 ------
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c  |   12 ++++++++----
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h |    6 ------
 drivers/net/wireless/rtlwifi/rtl8192se/def.h |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c  |   14 +++++++++-----
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |    2 +-
 drivers/net/wireless/rtlwifi/wifi.h          |    6 ++++++
 9 files changed, 33 insertions(+), 33 deletions(-)

-- 
1.7.6.1

