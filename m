Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33854 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbcFDLcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 07:32:18 -0400
From: =?UTF-8?q?Hugh=20Sipi=C3=A8re?= <hgsipiere@gmail.com>
To: m@bues.ch
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?UTF-8?q?Hugh=20Sipi=C3=A8re?= <hgsipiere@gmail.com>
Subject: [PATCH] drivers: ssb: Fix comments to suit coding style
Date: Sat,  4 Jun 2016 12:32:13 +0100
Message-Id: <1465039933-3984-1-git-send-email-hgsipiere@gmail.com> (sfid-20160604_133236_367676_DF67654A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I changed it so that these two comments do not end on a line with text.

Signed-off-by: Hugh Sipière <hgsipiere@gmail.com>
---
 drivers/ssb/driver_gpio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/driver_gpio.c b/drivers/ssb/driver_gpio.c
index 180e027..f2435f3 100644
--- a/drivers/ssb/driver_gpio.c
+++ b/drivers/ssb/driver_gpio.c
@@ -231,7 +231,8 @@ static int ssb_gpio_chipco_init(struct ssb_bus *bus)
 	chip->ngpio		= 16;
 	/* There is just one SoC in one device and its GPIO addresses should be
 	 * deterministic to address them more easily. The other buses could get
-	 * a random base number. */
+	 * a random base number.
+	 */
 	if (bus->bustype == SSB_BUSTYPE_SSB)
 		chip->base		= 0;
 	else
@@ -424,7 +425,8 @@ static int ssb_gpio_extif_init(struct ssb_bus *bus)
 	chip->ngpio		= 5;
 	/* There is just one SoC in one device and its GPIO addresses should be
 	 * deterministic to address them more easily. The other buses could get
-	 * a random base number. */
+	 * a random base number.
+	 */
 	if (bus->bustype == SSB_BUSTYPE_SSB)
 		chip->base		= 0;
 	else
-- 
2.5.5

