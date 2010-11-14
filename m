Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50423 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab0KNLgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 06:36:43 -0500
Received: by mail-ww0-f44.google.com with SMTP id 29so387874wwb.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Nov 2010 03:36:43 -0800 (PST)
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>, linux-wireless@vger.kernel.org,
	Mike Rapoport <mike.rapoport@gmail.com>
Subject: [PATCH 1/4] staging: brcm80211: remove unused osl_pkt{get,free}_static
Date: Sun, 14 Nov 2010 13:36:21 +0200
Message-Id: <b1ccf7bea4e2e07e24210371feb4fd1cd07d658b.1289734125.git.mike.rapoport@gmail.com>
In-Reply-To: <cover.1289734125.git.mike.rapoport@gmail.com>
References: <cover.1289734125.git.mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
---
 drivers/staging/brcm80211/include/linux_osl.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/include/linux_osl.h b/drivers/staging/brcm80211/include/linux_osl.h
index c9c860b..d2d5aa3 100644
--- a/drivers/staging/brcm80211/include/linux_osl.h
+++ b/drivers/staging/brcm80211/include/linux_osl.h
@@ -324,9 +324,6 @@ extern void *osl_pktget(osl_t *osh, uint len);
 extern void osl_pktfree(osl_t *osh, void *skb, bool send);
 
 #ifdef BRCM_FULLMAC
-extern void *osl_pktget_static(osl_t *osh, uint len);
-extern void osl_pktfree_static(osl_t *osh, void *skb, bool send);
-
 static inline void *
 osl_pkt_frmnative(osl_pubinfo_t *osh, struct sk_buff *skb)
 {
-- 
1.6.4.4

