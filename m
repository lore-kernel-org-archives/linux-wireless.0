Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42583 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbbA2Q0L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 11:26:11 -0500
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] net: rfkill: Add Broadcom BCM2E40 bluetooth ACPI ID
Date: Thu, 29 Jan 2015 18:26:00 +0200
Message-Id: <1422548760-56542-1-git-send-email-mika.westerberg@linux.intel.com> (sfid-20150129_172627_521503_053DE69B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is yet another Broadcom bluetooth chip with ACPI ID BCM2E40.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 net/rfkill/rfkill-gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 3f4a0bbeed3d..d978f2f46ff3 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -170,6 +170,7 @@ static const struct acpi_device_id rfkill_acpi_match[] = {
 	{ "BCM2E1A", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM2E39", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM2E3D", RFKILL_TYPE_BLUETOOTH },
+	{ "BCM2E40", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM2E64", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM4752", RFKILL_TYPE_GPS },
 	{ "LNV4752", RFKILL_TYPE_GPS },
-- 
2.1.4

