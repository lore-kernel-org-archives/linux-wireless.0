Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4269 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932412Ab1GNVaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:30:02 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 24/35] staging: brcm80211: brcmfmac: Enabling FW roaming
 by default
Date: Thu, 14 Jul 2011 14:29:20 -0700
Message-ID: <1310678971-28952-25-git-send-email-frankyl@broadcom.com> (sfid-20110714_233100_123756_A652B9DF)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

With this patch, FW roaming will be enabled by default in
brcmfmac driver

Signed-off-by: Sukesh Srikakula <sukeshs@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index d4d7c52..a915b6e 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3414,7 +3414,7 @@ static s32 wl_init_priv(struct brcmf_cfg80211_priv *cfg_priv)
 #endif /* WL_POWERSAVE_DISABLED */
 	cfg_priv->iscan_on = true;	/* iscan on & off switch.
 				 we enable iscan per default */
-	cfg_priv->roam_on = false;	/* roam on & off switch.
+	cfg_priv->roam_on = true;	/* roam on & off switch.
 				 we enable roam per default */
 
 	cfg_priv->iscan_kickstart = false;
-- 
1.7.1


