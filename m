Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:16932 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab0I0Iic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:32 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8c5EY024679
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 03:38:31 -0500
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8bogv022566
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:37:51 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 01/25] wl1271: remove deprecated ACX definition
Date: Mon, 27 Sep 2010 11:37:25 +0300
Message-Id: <1285576669-8070-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As of Rev. 6.1.0.0.335, the ACX_SET_SMART_REFLEX_DEBUG command is
deprecated.  This patch removes it from the wl1271 driver (it wasn't used
anyway).

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 4235bc5..5c8bb7f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -1060,7 +1060,6 @@ enum {
 	ACX_PEER_HT_CAP             = 0x0057,
 	ACX_HT_BSS_OPERATION        = 0x0058,
 	ACX_COEX_ACTIVITY           = 0x0059,
-	ACX_SET_SMART_REFLEX_DEBUG  = 0x005A,
 	ACX_SET_DCO_ITRIM_PARAMS    = 0x0061,
 	DOT11_RX_MSDU_LIFE_TIME     = 0x1004,
 	DOT11_CUR_TX_PWR            = 0x100D,
-- 
1.6.3.3

