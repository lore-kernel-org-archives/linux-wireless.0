Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4313 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab3K2LZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/19] brcmfmac: rename dhd_cdc to bcdc
Date: Fri, 29 Nov 2013 12:25:11 +0100
Message-ID: <1385724324-6361-7-git-send-email-arend@broadcom.com> (sfid-20131129_123807_881741_721EB1CB)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

dhd_cdc is renamed to bcdc. This is a step in cleaning and
restructuring protocol layer. This is done so new protocols can
be added in the future. This step only renames the source files.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile              |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/{dhd_cdc.c => bcdc.c} |    0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_cdc.c => bcdc.c} (100%)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 8e9b122..e15b61c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -28,7 +28,7 @@ brcmfmac-objs += \
 		fweh.o \
 		fwsignal.o \
 		p2p.o \
-		dhd_cdc.o \
+		bcdc.o \
 		dhd_common.o \
 		dhd_linux.o \
 		btcoex.o
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
similarity index 100%
rename from drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
rename to drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
-- 
1.7.10.4


