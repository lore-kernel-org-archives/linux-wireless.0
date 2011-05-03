Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1711 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1ECJgY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 46/61] staging: brcm80211: move aiutils source files to
 brcmsmac folder
Date: Tue, 3 May 2011 11:35:46 +0200
Message-ID: <1304415361-7813-47-git-send-email-arend@broadcom.com> (sfid-20110503_113649_525769_2C561C0F)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The aiutils functions are only used by the brcmsmac driver so it has
been moved to the driver specific folder.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/Makefile        |    2 +-
 .../staging/brcm80211/{util => brcmsmac}/aiutils.c |    0
 .../brcm80211/{include => brcmsmac}/aiutils.h      |    0
 3 files changed, 1 insertions(+), 1 deletions(-)
 rename drivers/staging/brcm80211/{util => brcmsmac}/aiutils.c (100%)
 rename drivers/staging/brcm80211/{include => brcmsmac}/aiutils.h (100%)

diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index 3d9e04b..8dc234d 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -41,12 +41,12 @@ BRCMSMAC_OFILES := \
 	wlc_pmu.o \
 	wlc_rate.o \
 	wlc_stf.o \
+	aiutils.o \
 	phy/wlc_phy_cmn.o \
 	phy/wlc_phy_lcn.o \
 	phy/wlc_phy_n.o \
 	phy/wlc_phytbl_lcn.o \
 	phy/wlc_phytbl_n.o \
-	../util/aiutils.o \
 	../util/bcmutils.o \
 	../util/bcmwifi.o \
 	../util/bcmotp.o \
diff --git a/drivers/staging/brcm80211/util/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
similarity index 100%
rename from drivers/staging/brcm80211/util/aiutils.c
rename to drivers/staging/brcm80211/brcmsmac/aiutils.c
diff --git a/drivers/staging/brcm80211/include/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
similarity index 100%
rename from drivers/staging/brcm80211/include/aiutils.h
rename to drivers/staging/brcm80211/brcmsmac/aiutils.h
-- 
1.7.4.1


