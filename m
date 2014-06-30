Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49430 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbaF3QSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 12:18:47 -0400
Received: by mail-wg0-f51.google.com with SMTP id x12so8203279wgg.34
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2014 09:18:46 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 3/7] rtl818x_pci: add comment pointing to the rtl8187se reference code
Date: Mon, 30 Jun 2014 18:18:36 +0200
Message-Id: <1404145117-15995-1-git-send-email-andrea.merello@gmail.com> (sfid-20140630_181856_298541_B6895375)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rtl8187se support has been added to the rtl818x_pci driver by extracting a lot
of information from a rtl8187se Linux staging driver included in the kernel at
the time rtl8187se support was added.
The rtl818x_pci main file has a comment that advertises this.

Recently this staging driver has been removed from the kernel, but I still feel
it can be useful as "reference" code (in case of bugs, or to implement
improvements in rtl818x_pci driver).

This one-line patch adds a comment in rtl818x_pci driver to point people
searching for that "reference code" to the last kernel version still containing
it (3.14).

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 73baf26..8a64bc1 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -16,6 +16,7 @@
  *
  * based also on:
  *  - portions of rtl8187se Linux staging driver, Copyright Realtek corp.
+ *    (available in drivers/staging/rtl8187se directory of Linux 3.14)
  *  - other GPL, unpublished (until now), Linux driver code,
  *    Copyright Larry Finger <Larry.Finger@lwfinger.net>
  *
-- 
1.9.1

