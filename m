Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544Ab2BMKYS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:18 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 15/24] iwleagcy: remove old comments
Date: Mon, 13 Feb 2012 11:23:22 +0100
Message-Id: <1329128611-6815-16-git-send-email-sgruszka@redhat.com> (sfid-20120213_112430_650418_BD014131)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.h |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index b2a6e52..a779445 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1626,22 +1626,6 @@ struct il_mod_params {
 	int restart_fw;		/* def: 1 = restart firmware */
 };
 
-/*
- * @led_compensation: compensate on the led on/off time per HW according
- *	to the deviation to achieve the desired led frequency.
- *	The detail algorithm is described in common.c
- * @chain_noise_num_beacons: number of beacons used to compute chain noise
- * @wd_timeout: TX queues watchdog timeout
- * @temperature_kelvin: temperature report by uCode in kelvin
- * @ucode_tracing: support ucode continuous tracing
- * @sensitivity_calib_by_driver: driver has the capability to perform
- *	sensitivity calibration operation
- * @chain_noise_calib_by_driver: driver has the capability to perform
- *	chain noise calibration operation
- */
-struct il_base_params {
-};
-
 #define IL_LED_SOLID 11
 #define IL_DEF_LED_INTRVL cpu_to_le32(1000)
 
-- 
1.7.1

