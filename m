Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755034AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 10/20] rtl8xxxu: Add bit definitions for REG_FPGA0_TX_INFO
Date: Fri, 19 Aug 2016 17:46:32 -0400
Message-Id: <1471643202-26250-11-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234817_347513_FB07BA36)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This adds TX antenna selection bit defines for OFDM mode.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 921c565..a338890 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -780,6 +780,10 @@
 #define  FPGA_RF_MODE_OFDM		BIT(25)
 
 #define REG_FPGA0_TX_INFO		0x0804
+#define  FPGA0_TX_INFO_OFDM_PATH_A	BIT(0)
+#define  FPGA0_TX_INFO_OFDM_PATH_B	BIT(1)
+#define  FPGA0_TX_INFO_OFDM_PATH_C	BIT(2)
+#define  FPGA0_TX_INFO_OFDM_PATH_D	BIT(3)
 #define REG_FPGA0_PSD_FUNC		0x0808
 #define REG_FPGA0_TX_GAIN		0x080c
 #define REG_FPGA0_RF_TIMING1		0x0810
-- 
2.7.4
