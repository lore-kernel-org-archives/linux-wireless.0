Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bluegiga.fi ([194.100.31.45]:30843 "EHLO darkblue.bluegiga.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab1KXTrT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 14:47:19 -0500
From: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Subject: [PATCH] hostap_cs: add ID for Canon K30225
Date: Thu, 24 Nov 2011 21:35:28 +0200
Message-Id: <1322163328-5791-1-git-send-email-veli-pekka.peltola@bluegiga.com> (sfid-20111124_204722_492418_516D2643)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
---
 drivers/net/wireless/hostap/hostap_cs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 5441ad1..89e9d3a 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -656,6 +656,9 @@ static const struct pcmcia_device_id hostap_cs_ids[] = {
 		"Addtron", "AWP-100 Wireless PCMCIA", "Version 01.02",
 		0xe6ec52ce, 0x08649af2, 0x4b74baa0),
 	PCMCIA_DEVICE_PROD_ID123(
+		"Canon", "Wireless LAN CF Card K30225", "Version 01.00",
+		0x96ef6fe2, 0x263fcbab, 0xa57adb8c),
+	PCMCIA_DEVICE_PROD_ID123(
 		"D", "Link DWL-650 11Mbps WLAN Card", "Version 01.02",
 		0x71b18589, 0xb6f1b0ab, 0x4b74baa0),
 	PCMCIA_DEVICE_PROD_ID123(
-- 
1.7.5.4

