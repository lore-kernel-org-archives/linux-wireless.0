Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:38271 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbaLDRhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 12:37:24 -0500
From: "Oh, Peter" <poh@qca.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] ath10k: add new pdev parameters for fw 10.2
Date: Thu, 4 Dec 2014 17:37:03 +0000
Message-ID: <b110385ccdfb4105a56625b0ef17ab2d@NASANEXM01B.na.qualcomm.com> (sfid-20141204_183727_842084_AB92B67B)
References: <20141202110443.14817.85639.stgit@potku.adurom.net>
 <20141202110653.14817.30464.stgit@potku.adurom.net>
In-Reply-To: <20141202110653.14817.30464.stgit@potku.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks good to me.

Thanks,
Peter

-----Original Message-----
From: ath10k [mailto:ath10k-bounces@lists.infradead.org] On Behalf Of Kalle Valo
Sent: Tuesday, December 02, 2014 3:07 AM
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/2] ath10k: add new pdev parameters for fw 10.2

From: Peter Oh <poh@qca.qualcomm.com>

New pdev paramters have been added to firmware 10.2, hence update wmi interfaces to sync with.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 7d091a74d3f3..4b31da5d3c4c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2793,6 +2793,9 @@ enum wmi_10x_pdev_param {
 	WMI_10X_PDEV_PARAM_SET_MCAST2UCAST_MODE,
 	WMI_10X_PDEV_PARAM_SET_MCAST2UCAST_BUFFER,
 	WMI_10X_PDEV_PARAM_REMOVE_MCAST2UCAST_BUFFER,
+	WMI_10X_PDEV_PARAM_PEER_STA_PS_STATECHG_ENABLE,
+	WMI_10X_PDEV_PARAM_RTS_FIXED_RATE,
+	WMI_10X_PDEV_PARAM_CAL_PERIOD
 };
 
 struct wmi_pdev_set_param_cmd {


_______________________________________________
ath10k mailing list
ath10k@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/ath10k
