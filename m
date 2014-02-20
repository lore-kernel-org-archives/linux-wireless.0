Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1716 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbaBTMvw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 07:51:52 -0500
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>
Cc: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] net: rfkill: gpio: add ACPI ID for GPS module on Lenove Miix2
Date: Thu, 20 Feb 2014 14:51:36 +0200
Message-Id: <1392900697-27577-4-git-send-email-heikki.krogerus@linux.intel.com> (sfid-20140220_135402_012711_6D24530F)
In-Reply-To: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Lenovo Miix 2 8", BCM4752 is renamed LNV4752.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 net/rfkill/rfkill-gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index ad5e354..ec38884 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -158,6 +158,7 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
 
 static const struct acpi_device_id rfkill_acpi_match[] = {
 	{ "BCM4752", RFKILL_TYPE_GPS },
+	{ "LNV4752", RFKILL_TYPE_GPS },
 	{ },
 };
 
-- 
1.9.0.rc3

