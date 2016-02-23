Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33271 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbcBWGiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 01:38:25 -0500
Received: by mail-pa0-f43.google.com with SMTP id fl4so105056767pad.0
        for <linux-wireless@vger.kernel.org>; Mon, 22 Feb 2016 22:38:24 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/7] staging: wilc1000: handle_cfg_param: fix logical continuations
Date: Tue, 23 Feb 2016 15:38:01 +0900
Message-Id: <1456209483-20345-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20160223_073827_789642_F04E1F24)
In-Reply-To: <1456209483-20345-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456209483-20345-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes logical continuations found by checkpatch
CHECK: Logical continuations should be on the previous line

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d207c5c..7d36d50 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -730,12 +730,12 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 	if (cfg_param_attr->flag & CURRENT_TX_RATE) {
 		enum CURRENT_TXRATE curr_tx_rate = cfg_param_attr->curr_tx_rate;
 
-		if (curr_tx_rate == AUTORATE || curr_tx_rate == MBPS_1
-		    || curr_tx_rate == MBPS_2 || curr_tx_rate == MBPS_5_5
-		    || curr_tx_rate == MBPS_11 || curr_tx_rate == MBPS_6
-		    || curr_tx_rate == MBPS_9 || curr_tx_rate == MBPS_12
-		    || curr_tx_rate == MBPS_18 || curr_tx_rate == MBPS_24
-		    || curr_tx_rate == MBPS_36 || curr_tx_rate == MBPS_48 || curr_tx_rate == MBPS_54) {
+		if (curr_tx_rate == AUTORATE || curr_tx_rate == MBPS_1 ||
+		    curr_tx_rate == MBPS_2 || curr_tx_rate == MBPS_5_5 ||
+		    curr_tx_rate == MBPS_11 || curr_tx_rate == MBPS_6 ||
+		    curr_tx_rate == MBPS_9 || curr_tx_rate == MBPS_12 ||
+		    curr_tx_rate == MBPS_18 || curr_tx_rate == MBPS_24 ||
+		    curr_tx_rate == MBPS_36 || curr_tx_rate == MBPS_48 || curr_tx_rate == MBPS_54) {
 			wid_list[i].id = WID_CURRENT_TX_RATE;
 			wid_list[i].val = (s8 *)&curr_tx_rate;
 			wid_list[i].type = WID_SHORT;
-- 
2.7.1

