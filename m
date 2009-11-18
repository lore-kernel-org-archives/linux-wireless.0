Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:44997 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZKRPWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 10:22:53 -0500
Received: by yxe17 with SMTP id 17so1073286yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 07:22:59 -0800 (PST)
From: janakiram.sistla@gmail.com
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Janakiram Sistla <janakiram.sistla@gmail.com>
Subject: [PATCH 2/2] Adding  kerneldoc entry for radio type GPS
Date: Wed, 18 Nov 2009 20:52:51 +0530
Message-Id: <1258557771-10776-1-git-send-email-janakiram.sistla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Janakiram Sistla <janakiram.sistla@gmail.com>


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

