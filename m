Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3296 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab1EIOdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Henry Ptasinski" <henryp@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 5/9] staging: brcm80211: remove unneeded include path
Date: Mon, 9 May 2011 16:33:06 +0200
Message-ID: <1304951590-2411-6-git-send-email-arend@broadcom.com> (sfid-20110509_163608_920262_A049AAD9)
In-Reply-To: <1304951590-2411-1-git-send-email-arend@broadcom.com>
References: <1304951590-2411-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

No include files are needed from the util directory, so remove that directory
from the include path.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index 4adbc4e..2732d7f 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -36,8 +36,7 @@ ccflags-$(CONFIG_BRCMDBG)	+= -DDHD_DEBUG
 
 ccflags-y += \
 	-Idrivers/staging/brcm80211/brcmfmac	\
-	-Idrivers/staging/brcm80211/include		\
-	-Idrivers/staging/brcm80211/util
+	-Idrivers/staging/brcm80211/include
 
 DHDOFILES = \
 	wl_cfg80211.o \
-- 
1.7.4.1


