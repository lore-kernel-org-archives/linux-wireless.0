Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58168 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab0IHXbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:31:01 -0400
Received: by pvg2 with SMTP id 2so254472pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:31:01 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Jason Spence <jspence@lightconsulting.com>,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 2/2] libertas_tf: Add Kconfig note about Wi2Wi device and firmware location.
Date: Wed,  8 Sep 2010 16:30:47 -0700
Message-Id: <1283988647-44747-2-git-send-email-steve@cozybit.com>
In-Reply-To: <1283988647-44747-1-git-send-email-steve@cozybit.com>
References: <1283988647-44747-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jason Spence <jspence@lightconsulting.com>

Signed-off-by: Jason Spence <jspence@lightconsulting.com>
Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/Kconfig |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index fc6c713..cb2e74e 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -49,7 +49,11 @@ config LIBERTAS_THINFIRM_SDIO
 	tristate "Marvell Libertas 8686 SDIO 802.11b/g cards"
 	depends on LIBERTAS_THINFIRM && MMC
 	---help---
-	  A driver for Marvell Libertas 8686 SDIO devices.
+	  A driver for Marvell Libertas 8686 SDIO devices and those that include
+	  the 88W8686 core, such as the Wi2Wi devices.  Special SDIO specific
+	  firmware is required to use this driver, see the OLPC site for details:
+
+	  <http://wiki.laptop.org/go/Thinfirm_1.5>
 
 config LIBERTAS_THINFIRM_USB
 	tristate "Marvell Libertas 8388 USB 802.11b/g cards with thin firmware"
-- 
1.7.0

