Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35604 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbcBWGi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 01:38:28 -0500
Received: by mail-pf0-f180.google.com with SMTP id c10so110312426pfc.2
        for <linux-wireless@vger.kernel.org>; Mon, 22 Feb 2016 22:38:27 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 6/7] staging: wilc1000: handle_cfg_param: fix line over 80 characters
Date: Tue, 23 Feb 2016 15:38:02 +0900
Message-Id: <1456209483-20345-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20160223_073830_892712_DB7C2A5D)
In-Reply-To: <1456209483-20345-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456209483-20345-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes line over 80 characters found by checkpatch
WARNING: line over 80 characters

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7d36d50..fb809a4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -735,7 +735,8 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		    curr_tx_rate == MBPS_11 || curr_tx_rate == MBPS_6 ||
 		    curr_tx_rate == MBPS_9 || curr_tx_rate == MBPS_12 ||
 		    curr_tx_rate == MBPS_18 || curr_tx_rate == MBPS_24 ||
-		    curr_tx_rate == MBPS_36 || curr_tx_rate == MBPS_48 || curr_tx_rate == MBPS_54) {
+		    curr_tx_rate == MBPS_36 || curr_tx_rate == MBPS_48 ||
+		    curr_tx_rate == MBPS_54) {
 			wid_list[i].id = WID_CURRENT_TX_RATE;
 			wid_list[i].val = (s8 *)&curr_tx_rate;
 			wid_list[i].type = WID_SHORT;
-- 
2.7.1

