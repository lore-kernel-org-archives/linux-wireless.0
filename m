Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45541 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab0IAVBy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 17:01:54 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: dwmw2@infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	ath9k-devel@atheros.com, Len Widra <len.widra@atheros.com>,
	Brian Lee <briank.lee@atheros.com>,
	Adam Tachner <atachner@atheros.com>,
	Paul Lever <Paul.Lever@atheros.com>,
	Vipin Mehta <vipin.mehta@atheros.com>
Subject: [PATCH] linux-firmware: update Atheros firmware license
Date: Wed,  1 Sep 2010 17:01:54 -0400
Message-Id: <1283374914-4554-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the license Operating System agnostic and updates
the patent license grant for use of the firmware license specifically
on the Atheros chipsets.

This allows us to share the same license between all Atheros chipsets,
ath9k, ath9k_htc, ath6kl, and future chipsets.

Cc: ath9k-devel@atheros.com
Cc: Len Widra <len.widra@atheros.com>
Cc: Brian Lee <briank.lee@atheros.com>
Cc: Adam Tachner <atachner@atheros.com>
Cc: Paul Lever <Paul.Lever@atheros.com>
Cc: Vipin Mehta <vipin.mehta@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 LICENCE.atheros_firmware |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/LICENCE.atheros_firmware b/LICENCE.atheros_firmware
index d336492..e0ebdac 100644
--- a/LICENCE.atheros_firmware
+++ b/LICENCE.atheros_firmware
@@ -21,9 +21,7 @@ world-wide, royalty-free, non-exclusive license under patents it
 now or hereafter owns or controls to make, have made, use, import,
 offer to sell and sell ("Utilize") this software, but solely to
 the extent that any such patent is necessary to Utilize the software
-alone, or in combination with an operating system licensed under an
-approved Open Source license as listed by the Open Source Initiative
-at http://opensource.org/licenses.  The patent license shall not
+in conjunction with an Atheros Chipset. The patent license shall not
 apply to any other combinations which include this software. No
 hardware per se is licensed hereunder.
 
-- 
1.7.0.4

