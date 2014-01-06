Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:59121 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaAFLkz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:55 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 02/15] brcmfmac: Remove some obsolete definitions and variables.
Date: Mon, 6 Jan 2014 12:40:37 +0100
Message-ID: <1389008450-28529-3-git-send-email-arend@broadcom.com> (sfid-20140106_124059_421765_BA194131)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h        |    2 --
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c |    2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 252024b..e299657 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -21,8 +21,6 @@
 #ifndef _BRCMF_H_
 #define _BRCMF_H_
 
-#define BRCMF_VERSION_STR		"4.218.248.5"
-
 #include "fweh.h"
 
 #define TOE_TX_CSUM_OL		0x00000001
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 7b6bdd1..6a8983a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -32,8 +32,6 @@
 #define BRCMF_DEFAULT_SCAN_UNASSOC_TIME	40
 #define BRCMF_DEFAULT_PACKET_FILTER	"100 0 0 0 0x01 0x00"
 
-static const char brcmf_version[] =
-	"Dongle Host Driver, version " BRCMF_VERSION_STR;
 
 bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 		      struct sk_buff *pkt, int prec)
-- 
1.7.10.4

