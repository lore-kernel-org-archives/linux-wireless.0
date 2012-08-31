Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58142 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab2HaUjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2012 16:39:37 -0400
Received: by iahk25 with SMTP id k25so1839643iah.19
        for <linux-wireless@vger.kernel.org>; Fri, 31 Aug 2012 13:39:36 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/3 V2] Updates for rtlwifi family
Date: Fri, 31 Aug 2012 15:38:58 -0500
Message-Id: <1346445541-5251-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120831_223941_458749_3F8E7B8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches replace an earlier version that contained 6 patches. Numbers 4-6
have been abandoned for the moment. Other than the change in the subject,
these 3 patches are unchanged from the previous version.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>


Larry Finger (3):
  rtlwifi: rtl8192c: rtl8192de: Fix typo in cursta_connectctate
  rtlwifi: rtl8192c: rtl8192ce: rtl8192cu: rtl8192se: Remove sparse
    warnings
  rtlwifi: Update header file

 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |   41 ++++----
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c       |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c      |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c       |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c      |    6 +-
 drivers/net/wireless/rtlwifi/usb.c                |    2 +-
 drivers/net/wireless/rtlwifi/wifi.h               |  108 +++++++++++++++++++--
 8 files changed, 130 insertions(+), 45 deletions(-)

-- 
1.7.10.4

