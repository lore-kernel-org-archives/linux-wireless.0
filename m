Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2252 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab3K2LZl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:41 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 17/19] brcmfmac: remove some unused definitions
Date: Fri, 29 Nov 2013 12:25:22 +0100
Message-ID: <1385724324-6361-18-git-send-email-arend@broadcom.com> (sfid-20131129_122559_155744_8D228FB0)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing WLC_PHY_TYPE and some BRCMF_E_.* definitions as these
are not used in the driver sources.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h |   48 -------------------------
 1 file changed, 48 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index a85f9db..da5cf00 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -25,17 +25,6 @@
 
 #include "fweh.h"
 
-/* phy types (returned by WLC_GET_PHYTPE) */
-#define	WLC_PHY_TYPE_A		0
-#define	WLC_PHY_TYPE_B		1
-#define	WLC_PHY_TYPE_G		2
-#define	WLC_PHY_TYPE_N		4
-#define	WLC_PHY_TYPE_LP		5
-#define	WLC_PHY_TYPE_SSN	6
-#define	WLC_PHY_TYPE_HT		7
-#define	WLC_PHY_TYPE_LCN	8
-#define	WLC_PHY_TYPE_NULL	0xf
-
 #define TOE_TX_CSUM_OL		0x00000001
 #define TOE_RX_CSUM_OL		0x00000002
 
@@ -75,38 +64,6 @@
 #define BRCMF_E_REASON_TSPEC_REJECTED		7
 #define BRCMF_E_REASON_BETTER_AP		8
 
-#define BRCMF_E_PRUNE_ENCR_MISMATCH		1
-#define BRCMF_E_PRUNE_BCAST_BSSID		2
-#define BRCMF_E_PRUNE_MAC_DENY			3
-#define BRCMF_E_PRUNE_MAC_NA			4
-#define BRCMF_E_PRUNE_REG_PASSV			5
-#define BRCMF_E_PRUNE_SPCT_MGMT			6
-#define BRCMF_E_PRUNE_RADAR			7
-#define BRCMF_E_RSN_MISMATCH			8
-#define BRCMF_E_PRUNE_NO_COMMON_RATES		9
-#define BRCMF_E_PRUNE_BASIC_RATES		10
-#define BRCMF_E_PRUNE_CIPHER_NA			12
-#define BRCMF_E_PRUNE_KNOWN_STA			13
-#define BRCMF_E_PRUNE_WDS_PEER			15
-#define BRCMF_E_PRUNE_QBSS_LOAD			16
-#define BRCMF_E_PRUNE_HOME_AP			17
-
-#define BRCMF_E_SUP_OTHER			0
-#define BRCMF_E_SUP_DECRYPT_KEY_DATA		1
-#define BRCMF_E_SUP_BAD_UCAST_WEP128		2
-#define BRCMF_E_SUP_BAD_UCAST_WEP40		3
-#define BRCMF_E_SUP_UNSUP_KEY_LEN		4
-#define BRCMF_E_SUP_PW_KEY_CIPHER		5
-#define BRCMF_E_SUP_MSG3_TOO_MANY_IE		6
-#define BRCMF_E_SUP_MSG3_IE_MISMATCH		7
-#define BRCMF_E_SUP_NO_INSTALL_FLAG		8
-#define BRCMF_E_SUP_MSG3_NO_GTK			9
-#define BRCMF_E_SUP_GRP_KEY_CIPHER		10
-#define BRCMF_E_SUP_GRP_MSG1_NO_GTK		11
-#define BRCMF_E_SUP_GTK_DECRYPT_FAIL		12
-#define BRCMF_E_SUP_SEND_FAIL			13
-#define BRCMF_E_SUP_DEAUTH			14
-
 #define BRCMF_E_IF_ADD				1
 #define BRCMF_E_IF_DEL				2
 #define BRCMF_E_IF_CHANGE			3
@@ -117,11 +74,6 @@
 #define BRCMF_E_IF_ROLE_AP			1
 #define BRCMF_E_IF_ROLE_WDS			2
 
-#define BRCMF_E_LINK_BCN_LOSS			1
-#define BRCMF_E_LINK_DISASSOC			2
-#define BRCMF_E_LINK_ASSOC_REC			3
-#define BRCMF_E_LINK_BSSCFG_DIS			4
-
 /* Small, medium and maximum buffer size for dcmd
  */
 #define BRCMF_DCMD_SMLEN	256
-- 
1.7.10.4


