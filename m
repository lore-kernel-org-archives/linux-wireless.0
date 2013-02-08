Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4649 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760209Ab3BHO4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:42 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 25/27] brcmfmac: Cleanup of unused defines.
Date: Fri, 8 Feb 2013 15:54:00 +0100
Message-ID: <1360335242-12608-26-git-send-email-arend@broadcom.com> (sfid-20130208_163815_023012_79192368)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Remove some unused defines and comments. Also use same define
for IE length.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h         |    6 ------
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h |    2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
index 8fed9a3..9e0e962 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
@@ -20,12 +20,6 @@
 
 struct brcmf_cfg80211_info;
 
-/* vendor ies max buffer length for probe response or beacon */
-#define VNDR_IES_MAX_BUF_LEN 1400
-/* normal vendor ies buffer length */
-#define VNDR_IES_BUF_LEN 512
-
-/* Structure to hold all saved P2P and WPS IEs for a BSSCFG */
 /**
  * enum p2p_bss_type - different type of BSS configurations.
  *
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index a020555..b886f22 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -172,7 +172,7 @@ enum brcmf_vif_status {
  * @beacon_ie_len: IE info length for beacon frame.
  */
 struct vif_saved_ie {
-	u8  probe_req_ie[VNDR_IES_BUF_LEN];
+	u8  probe_req_ie[IE_MAX_LEN];
 	u8  probe_res_ie[IE_MAX_LEN];
 	u8  beacon_ie[IE_MAX_LEN];
 	u8  assoc_req_ie[IE_MAX_LEN];
-- 
1.7.10.4


