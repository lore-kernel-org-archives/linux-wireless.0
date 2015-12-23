Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49551 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbbLWNH0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 08:07:26 -0500
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] net: rfkill-gpio: more ACPI IDs for BCM Blutooth modules
Date: Wed, 23 Dec 2015 15:07:01 +0200
Message-Id: <1450876021-806-1-git-send-email-heikki.krogerus@linux.intel.com> (sfid-20151223_140729_730903_E7095902)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are used with BCM43241 Wi-Fi/Bluetooth Combo Device.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 net/rfkill/rfkill-gpio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 9312722..ba6d61d 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -164,9 +164,12 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id rfkill_acpi_match[] = {
 	{ "BCM2E1A", RFKILL_TYPE_BLUETOOTH },
+	{ "BCM2E3A", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM2E3D", RFKILL_TYPE_BLUETOOTH },
+	{ "BCM2E3F", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM2E40", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM2E64", RFKILL_TYPE_BLUETOOTH },
+	{ "BCM2E7B", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM4752", RFKILL_TYPE_GPS },
 	{ "LNV4752", RFKILL_TYPE_GPS },
 	{ },
-- 
2.6.4

