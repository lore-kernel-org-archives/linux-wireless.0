Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1768 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab1HHN7d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Sukesh Srikakula" <sukeshs@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 25/82] staging: brcm80211: brcmfmac: Enabling FW
 roaming by default
Date: Mon, 8 Aug 2011 15:58:09 +0200
Message-ID: <1312811946-16713-26-git-send-email-arend@broadcom.com> (sfid-20110808_155952_870368_0D5C6542)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
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
Signed-off-by: Arend van Spriel <arend@broadcom.com>
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
1.7.4.1


