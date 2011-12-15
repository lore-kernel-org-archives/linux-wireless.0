Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46601 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab1LOEQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 23:16:44 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so2176479iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 20:16:44 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 1/3] ath: add a debug level for DFS
Date: Wed, 14 Dec 2011 20:16:32 -0800
Message-Id: <1323922595-15533-2-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111215_051647_433074_DB6FCF84)
In-Reply-To: <1323922595-15533-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1323922595-15533-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zefir Kurtisi <zefir.kurtisi@neratec.com>

This can later be used by other drivers that implement
DFS support.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 0b93bab..c1d699f 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -218,6 +218,7 @@ do {								\
  * @ATH_DBG_MCI: Message Coexistence Interface, a private protocol
  *	used exclusively for WLAN-BT coexistence starting from
  *	AR9462.
+ * @ATH_DBG_DFS: radar datection
  * @ATH_DBG_ANY: enable all debugging
  *
  * The debug level is used to control the amount and type of debugging output
@@ -244,6 +245,7 @@ enum ATH_DEBUG {
 	ATH_DBG_WMI		= 0x00004000,
 	ATH_DBG_BSTUCK		= 0x00008000,
 	ATH_DBG_MCI		= 0x00010000,
+	ATH_DBG_DFS		= 0x00020000,
 	ATH_DBG_ANY		= 0xffffffff
 };
 
-- 
1.7.4.15.g7811d

