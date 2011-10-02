Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1731 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab1JBRO6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:14:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 01/20] staging: brmc80211: removed some unused fmac
 variable declarations
Date: Sun, 2 Oct 2011 10:14:26 -0700
Message-ID: <1317575685-3156-2-git-send-email-frankyl@broadcom.com> (sfid-20111002_191504_929864_670D44BE)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h |   29 -----------------------------
 1 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 514f779..be6c620 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -683,36 +683,7 @@ struct bcmevent_name {
 	const char *name;
 };
 
-/* Override to force tx queueing all the time */
-extern uint brcmf_force_tx_queueing;
-
 extern const struct bcmevent_name bcmevent_names[];
-extern const int bcmevent_names_size;
-
-
-static inline void MUTEX_LOCK_INIT(struct brcmf_pub *drvr)
-{
-}
-
-static inline void MUTEX_LOCK(struct brcmf_pub *drvr)
-{
-}
-
-static inline void MUTEX_UNLOCK(struct brcmf_pub *drvr)
-{
-}
-
-static inline void MUTEX_LOCK_WL_SCAN_SET_INIT(void)
-{
-}
-
-static inline void MUTEX_LOCK_WL_SCAN_SET(void)
-{
-}
-
-static inline void MUTEX_UNLOCK_WL_SCAN_SET(void)
-{
-}
 
 /* Indication from bus module regarding presence/insertion of dongle.
  * Return struct brcmf_pub pointer, used as handle to OS module in later calls.
-- 
1.7.1


