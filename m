Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44918 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbZKRP4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 10:56:39 -0500
Received: by bwz27 with SMTP id 27so1271367bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 07:56:44 -0800 (PST)
From: janakiram.sistla@gmail.com
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Janakiram Sistla <janakiram.sistla@gmail.com>
Subject: [PATCH 2/2] Adding  kerneldoc entry for radio type GPS
Date: Wed, 18 Nov 2009 21:26:39 +0530
Message-Id: <1258559799-12649-1-git-send-email-janakiram.sistla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Janakiram Sistla <janakiram.sistla@gmail.com>

Adding  kerneldoc entry for radio type GPS
Signed-off-by: Janakiram Sistla <janakiram.sistla@gmail.com>
---
 include/linux/rfkill.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index d787d5f..212f555 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -36,6 +36,7 @@
  * @RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
  * @RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
  * @RFKILL_TYPE_FM: switch is on a FM device.
+ * @RFKILL_TYPE_GPS: switch is on a GPS device.
  * @NUM_RFKILL_TYPES: number of defined rfkill types
  */
 enum rfkill_type {
-- 
1.5.4.3

