Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:41912 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbbGMWM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2015 18:12:27 -0400
Message-ID: <1436825494.20249.47.camel@hadess.net> (sfid-20150714_001250_349853_AF74ECEB)
Subject: [PATCH] rfkill-gpio: Add support for the Realtek 8723 BT
From: Bastien Nocera <hadess@hadess.net>
To: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Tue, 14 Jul 2015 00:11:34 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://thread.gmane.org/gmane.linux.kernel.wireless.general/127706/focu
s=127896

Signed-off-by: Bastien Nocera <hadess@hadess.net>

---
 net/rfkill/rfkill-gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index d5d58d9..9471024 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -168,6 +168,7 @@ static const struct acpi_device_id
rfkill_acpi_match[] = {
 	{ "BCM2E3D", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM2E40", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM2E64", RFKILL_TYPE_BLUETOOTH },
+	{ "OBDA8723", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM4752", RFKILL_TYPE_GPS },
 	{ "LNV4752", RFKILL_TYPE_GPS },
 	{ },
-- 
2.4.3
