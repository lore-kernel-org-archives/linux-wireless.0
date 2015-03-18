Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:55701 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbbCRMZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 08:25:34 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/8] brcmfmac: Update msgbuf commonring size for improved throughput.
Date: Wed, 18 Mar 2015 13:25:23 +0100
Message-ID: <1426681528-15831-4-git-send-email-arend@broadcom.com> (sfid-20150318_132544_922098_B7DD658A)
In-Reply-To: <1426681528-15831-1-git-send-email-arend@broadcom.com>
References: <1426681528-15831-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h
index 77a51b8..3d513e4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h
@@ -17,11 +17,11 @@
 
 #ifdef CONFIG_BRCMFMAC_PROTO_MSGBUF
 
-#define BRCMF_H2D_MSGRING_CONTROL_SUBMIT_MAX_ITEM	20
-#define BRCMF_H2D_MSGRING_RXPOST_SUBMIT_MAX_ITEM	256
-#define BRCMF_D2H_MSGRING_CONTROL_COMPLETE_MAX_ITEM	20
+#define BRCMF_H2D_MSGRING_CONTROL_SUBMIT_MAX_ITEM	64
+#define BRCMF_H2D_MSGRING_RXPOST_SUBMIT_MAX_ITEM	512
+#define BRCMF_D2H_MSGRING_CONTROL_COMPLETE_MAX_ITEM	64
 #define BRCMF_D2H_MSGRING_TX_COMPLETE_MAX_ITEM		1024
-#define BRCMF_D2H_MSGRING_RX_COMPLETE_MAX_ITEM		256
+#define BRCMF_D2H_MSGRING_RX_COMPLETE_MAX_ITEM		512
 #define BRCMF_H2D_TXFLOWRING_MAX_ITEM			512
 
 #define BRCMF_H2D_MSGRING_CONTROL_SUBMIT_ITEMSIZE	40
-- 
1.9.1

