Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4480 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab2JVUz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:55:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/12] brcmfmac: remove unused enumeration wl_prof_list
Date: Mon, 22 Oct 2012 13:55:36 -0700
Message-ID: <1350939341-17687-8-git-send-email-frankyl@broadcom.com> (sfid-20121022_225606_614631_74144534)
In-Reply-To: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
References: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The enumeration wl_prof_list is no longer used so it can be safely
removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 08ca390..85f3adf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -145,19 +145,6 @@ enum wl_mode {
 	WL_MODE_AP
 };
 
-/* dongle profile list */
-enum wl_prof_list {
-	WL_PROF_MODE,
-	WL_PROF_SSID,
-	WL_PROF_SEC,
-	WL_PROF_IBSS,
-	WL_PROF_BAND,
-	WL_PROF_BSSID,
-	WL_PROF_ACT,
-	WL_PROF_BEACONINT,
-	WL_PROF_DTIMPERIOD
-};
-
 /* dongle iscan state */
 enum wl_iscan_state {
 	WL_ISCAN_STATE_IDLE,
-- 
1.7.9.5


