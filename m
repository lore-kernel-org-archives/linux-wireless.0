Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44914 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511Ab0I3BpG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 21:45:06 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 02:44:56 +0100
Message-ID: <1285811096.3916.9.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH] ar9170: Remove MODULE_FIRMWARE references to two-stage
 firmware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The combined firmware ar9170.fw is preferred and supports all devices.
References to the older two-stage firmware are unnecessary.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ar9170/usb.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index a93dc18..5dbb536 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -54,8 +54,6 @@ MODULE_AUTHOR("Christian Lamparter <chunkeey@web.de>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Atheros AR9170 802.11n USB wireless");
 MODULE_FIRMWARE("ar9170.fw");
-MODULE_FIRMWARE("ar9170-1.fw");
-MODULE_FIRMWARE("ar9170-2.fw");
 
 enum ar9170_requirements {
 	AR9170_REQ_FW1_ONLY = 1,
-- 
1.7.1


