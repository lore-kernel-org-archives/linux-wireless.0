Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2234 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758790Ab1FALq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 38/83] staging: brcm80211: move PCI related header files
 to appropriate driver folder
Date: Wed, 1 Jun 2011 13:45:23 +0200
Message-ID: <1306928768-7501-38-git-send-email-rvossen@broadcom.com> (sfid-20110601_134711_128157_78046871)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The include file pcicfg.h is now only required by brcmfmac driver. Similarly,
nicpci.h is only required by brcmsmac driver. These header files have been
moved to the appropriate driver specific folder.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 .../brcm80211/{include => brcmfmac}/pcicfg.h       |    0
 .../brcm80211/{include => brcmsmac}/nicpci.h       |    0
 2 files changed, 0 insertions(+), 0 deletions(-)
 rename drivers/staging/brcm80211/{include => brcmfmac}/pcicfg.h (100%)
 rename drivers/staging/brcm80211/{include => brcmsmac}/nicpci.h (100%)

diff --git a/drivers/staging/brcm80211/include/pcicfg.h b/drivers/staging/brcm80211/brcmfmac/pcicfg.h
similarity index 100%
rename from drivers/staging/brcm80211/include/pcicfg.h
rename to drivers/staging/brcm80211/brcmfmac/pcicfg.h
diff --git a/drivers/staging/brcm80211/include/nicpci.h b/drivers/staging/brcm80211/brcmsmac/nicpci.h
similarity index 100%
rename from drivers/staging/brcm80211/include/nicpci.h
rename to drivers/staging/brcm80211/brcmsmac/nicpci.h
-- 
1.7.4.1


