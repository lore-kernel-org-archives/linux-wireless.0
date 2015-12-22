Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34850 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbbLVAtc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 19:49:32 -0500
Received: by mail-pf0-f178.google.com with SMTP id 78so23899974pfw.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 16:49:32 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/13] staging: wilc1000: remove wilc_set_start_scan_req declaration
Date: Tue, 22 Dec 2015 09:49:02 +0900
Message-Id: <1450745349-16811-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20151222_014935_455172_3D7E1232)
In-Reply-To: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch deletes wilc_set_start_scan_req declaration. It is not find
wilc_set_start_scan_req definition in this driver.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index a21ca37..1e3f389 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -326,7 +326,6 @@ s32 wilc_set_pmkid_info(struct wilc_vif *vif,
 s32 wilc_get_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
 s32 wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
 int wilc_wait_msg_queue_idle(void);
-s32 wilc_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource);
 s32 wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
 		      size_t ssidLen, const u8 *pu8IEs, size_t IEsLen,
 		      wilc_connect_result pfConnectResult, void *pvUserArg,
-- 
2.6.4

