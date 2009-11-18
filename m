Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55285 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZKRPsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 10:48:00 -0500
From: Marcel Holtmann <marcel@holtmann.org>
To: linux-wireless@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 1/2] rfkill: Add missing description for RFKILL_TYPE_GPS
Date: Wed, 18 Nov 2009 16:48:00 +0100
Message-Id: <1258559281-20935-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 include/linux/rfkill.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 3392c59..a75e9e5 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -35,6 +35,7 @@
  * @RFKILL_TYPE_UWB: switch is on a ultra wideband device.
  * @RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
  * @RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
+ * @RFKILL_TYPE_GPS: switch is on a GPS device.
  * @NUM_RFKILL_TYPES: number of defined rfkill types
  */
 enum rfkill_type {
-- 
1.6.3.3

