Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62364 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab1I2Rmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 13:42:31 -0400
Received: by pzk1 with SMTP id 1so2245599pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2011 10:42:31 -0700 (PDT)
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>, s.kirste@avm.de,
	d.friedel@avm.de, Martin Walter <m.walter@avm.de>,
	Peter Grabienski <pgrabien@qca.qualcomm.com>, stable@kernel.org
Subject: [PATCH] ath9k_htc: add AVM FRITZ!WLAN 11N v2 support
Date: Thu, 29 Sep 2011 10:42:19 -0700
Message-Id: <1317318139-28386-1-git-send-email-lrodriguez@qca.qualcomm.com> (sfid-20110929_194239_419170_11DB9CA0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

This was reported and tested by Martin Walter over at AVM GmbH Berlin.
This also applies to 3.0.1 so sendint to stable.

Cc: s.kirste@avm.de
Cc: d.friedel@avm.de
Cc: Martin Walter <m.walter@avm.de>
Cc: Peter Grabienski <pgrabien@qca.qualcomm.com>
Cc: stable@kernel.org
Tested-by: Martin Walter <m.walter@avm.de>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index d3f4a59..77c8ded 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -38,6 +38,7 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x04CA, 0x4605) }, /* Liteon */
 	{ USB_DEVICE(0x040D, 0x3801) }, /* VIA */
 	{ USB_DEVICE(0x0cf3, 0xb003) }, /* Ubiquiti WifiStation Ext */
+	{ USB_DEVICE(0x057c, 0x8403) }, /* AVM FRITZ!WLAN 11N v2 USB */
 
 	{ USB_DEVICE(0x0cf3, 0x7015),
 	  .driver_info = AR9287_USB },  /* Atheros */
-- 
1.7.4.15.g7811d

