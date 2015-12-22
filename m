Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34457 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbbLVAt3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 19:49:29 -0500
Received: by mail-pa0-f50.google.com with SMTP id uo6so2843078pac.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 16:49:29 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/13] staging: wilc1000: remove wilc_add_tx_gtk declaration
Date: Tue, 22 Dec 2015 09:49:01 +0900
Message-Id: <1450745349-16811-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20151222_014932_081483_8225B0C7)
In-Reply-To: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch deletes wilc_add_tx_gtk declaration. It is not find
wilc_add_tx_gtk definition in this driver.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 6a5f3bd..a21ca37 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -321,8 +321,6 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 		    u8 index, u32 key_rsc_len, const u8 *key_rsc,
 		    const u8 *rx_mic, const u8 *tx_mic, u8 mode,
 		    u8 cipher_mode);
-s32 wilc_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen,
-			u8 *pu8TxGtk, u8 u8KeyIdx);
 s32 wilc_set_pmkid_info(struct wilc_vif *vif,
 			struct host_if_pmkid_attr *pu8PmkidInfoArray);
 s32 wilc_get_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
-- 
2.6.4

