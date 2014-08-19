Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35024 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbaHSMmS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 08:42:18 -0400
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net: rfkill: gpio: Add more Broadcom bluetooth ACPI IDs
Date: Tue, 19 Aug 2014 15:41:32 +0300
Message-Id: <1408452092-13664-1-git-send-email-mika.westerberg@linux.intel.com> (sfid-20140819_144249_691713_8ABDE08F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds one more ACPI ID of a Broadcom bluetooth chip.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 net/rfkill/rfkill-gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 14c98e48f261..02a86a27fd84 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -158,6 +158,7 @@ static const struct acpi_device_id rfkill_acpi_match[] = {
 	{ "BCM2E1A", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM2E39", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM2E3D", RFKILL_TYPE_BLUETOOTH },
+	{ "BCM2E64", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM4752", RFKILL_TYPE_GPS },
 	{ "LNV4752", RFKILL_TYPE_GPS },
 	{ },
-- 
2.1.0

