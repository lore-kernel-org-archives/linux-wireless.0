Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965929AbcBCSkH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:07 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 28/28] rtl8xxxu: Add missing bit define for REG_APS_FSMCO
Date: Wed,  3 Feb 2016 13:40:02 -0500
Message-Id: <1454524802-26763-29-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194103_462823_1768C8C4)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index d089edd..8f6c9c6 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -45,6 +45,7 @@
 #define  APS_FSMCO_ENABLE_POWERDOWN	BIT(4)
 #define  APS_FSMCO_MAC_ENABLE		BIT(8)
 #define  APS_FSMCO_MAC_OFF		BIT(9)
+#define  APS_FSMCO_SW_LPS		BIT(10)
 #define  APS_FSMCO_HW_SUSPEND		BIT(11)
 #define  APS_FSMCO_PCIE			BIT(12)
 #define  APS_FSMCO_HW_POWERDOWN		BIT(15)
-- 
2.5.0

