Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:31039 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbbKXRjP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 12:39:15 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath10k: introduce new subtypes for proxy STA and Mesh
Date: Tue, 24 Nov 2015 09:37:34 -0800
Message-ID: <1448386655-13936-3-git-send-email-poh@qca.qualcomm.com> (sfid-20151124_183922_217381_FE437CA3)
In-Reply-To: <1448386655-13936-1-git-send-email-poh@qca.qualcomm.com>
References: <1448386655-13936-1-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

QCA988X firmware starting from 10.2.4.70.12-2 supports new
vdev subtypes for proxy STA and Mesh, hence add them to be used
as needed.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 0747055..d85ad78 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4274,6 +4274,8 @@ enum wmi_vdev_subtype {
 	WMI_VDEV_SUBTYPE_P2P_DEVICE = 1,
 	WMI_VDEV_SUBTYPE_P2P_CLIENT = 2,
 	WMI_VDEV_SUBTYPE_P2P_GO     = 3,
+	WMI_VDEV_SUBTYPE_PROXY_STA	= 4,
+	WMI_VDEV_SUBTYPE_MESH		= 5,
 };
 
 /* values for vdev_subtype */
-- 
1.9.1

