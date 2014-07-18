Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36709 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759713AbaGRFh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 01:37:26 -0400
Received: by mail-wg0-f48.google.com with SMTP id x13so2993417wgg.7
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 22:37:25 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/9] staging: vt6656: struct vnt_private remove dead variables
Date: Fri, 18 Jul 2014 06:36:13 +0100
Message-Id: <1405661776-3345-6-git-send-email-tvboxspy@gmail.com> (sfid-20140718_073734_365480_8E43D6E3)
In-Reply-To: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
References: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index f3ff6f5..8257a64 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -381,8 +381,6 @@ struct vnt_private {
 
 	enum vnt_cmd command;
 
-	int bStopDataPkt;
-
 	/* 802.11 counter */
 
 	enum vnt_cmd cmd_queue[CMD_Q_SIZE];
@@ -396,22 +394,15 @@ struct vnt_private {
 	u8 byAutoFBCtrl;
 
 	/* For Update BaseBand VGA Gain Offset */
-	u32 uBBVGADiffCount;
-	u8 byBBVGANew;
-	u8 byBBVGACurrent;
 	u8 abyBBVGA[BB_VGA_LEVEL];
 	signed long ldBmThreshold[BB_VGA_LEVEL];
 
 	u8 byBBPreEDRSSI;
 	u8 byBBPreEDIndex;
 
-	int bRadioCmd;
-
 	/* command timer */
 	struct delayed_work run_command_work;
 
-	u8 tx_data_time_out;
-
 	int bChannelSwitch;
 	u8 byNewChannel;
 	u8 byChannelSwitchCount;
-- 
2.0.1

