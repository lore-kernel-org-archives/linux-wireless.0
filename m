Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:40927 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3IMRpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 13:45:14 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 0/7] rtlwifi: Patches to fix problems shown by smatch
Date: Fri, 13 Sep 2013 12:44:57 -0500
Message-Id: <1379094304-22041-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130913_194518_640903_AFB0AA27)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

*** BLURB HERE ***

Larry Finger (7):
  rtlwifi: rtl8192du: Fix smatch errors in /rtl8192de/dm.c
  rtlwifi: rtl8192de: Fix smatch warnings in rtl8192de/hw.c
  rtlwifi: rtl8192cu: Fix smatch warning in rtl8192cu/trx.c
  rtlwifi: rtl8192_common: Fix smatch errors and warnings in
    rtl8192c/dm_common.c
  rtlwifi: Fix smatch warning in pci.c
  rtlwifi: Fix smatch warnings in usb.c
  rtlwifi: rtl8188ee: Fix smatch warning in rtl8188ee/hw.c

 drivers/net/wireless/rtlwifi/pci.c                |   2 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c       |   1 +
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |   4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c      | 187 +---------------------
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c      |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c       |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c       |   2 +
 drivers/net/wireless/rtlwifi/usb.c                |  10 +-
 8 files changed, 23 insertions(+), 193 deletions(-)

-- 
1.8.1.4

