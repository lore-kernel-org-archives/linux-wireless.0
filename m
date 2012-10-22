Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1874 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902Ab2JVRgl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:36:41 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/14] brcmfmac: remove brcmf_find_bssidx() function
Date: Mon, 22 Oct 2012 10:36:27 -0700
Message-ID: <1350927387-25608-15-git-send-email-frankyl@broadcom.com> (sfid-20121022_193656_160091_02EC5981)
In-Reply-To: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
References: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function brcmf_find_bssidx() is no longer used so remove
it from the driver code.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 71bc310..069a4e4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -514,16 +514,6 @@ done:
 	return err;
 }
 
-/*
- * For now brcmf_find_bssidx will return 0. Once p2p gets implemented this
- * should return the ndev matching bssidx.
- */
-static s32
-brcmf_find_bssidx(struct brcmf_cfg80211_info *cfg, struct net_device *ndev)
-{
-	return 0;
-}
-
 static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 {
 	s32 err = 0;
-- 
1.7.6


