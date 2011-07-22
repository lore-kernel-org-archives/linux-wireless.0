Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1635 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093Ab1GVS5m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:42 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 29/29] staging: brcm80211: updated TODO file
Date: Fri, 22 Jul 2011 20:57:16 +0200
Message-ID: <1311361036-3175-30-git-send-email-arend@broadcom.com> (sfid-20110722_205749_813177_6AC43B67)
In-Reply-To: <1311361036-3175-1-git-send-email-arend@broadcom.com>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only remaining TODO item has been tackled so it was removed. No
other TODO items left.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/TODO |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/TODO b/drivers/staging/brcm80211/TODO
index e2e2ef9..7f68762 100644
--- a/drivers/staging/brcm80211/TODO
+++ b/drivers/staging/brcm80211/TODO
@@ -4,10 +4,6 @@ Bugs
 ====
 - none known at this moment
 
-brcmfmac
-=====================
-- ASSERTS deprecated in mainline, replace by warning + error handling
-
 brcm80211 info page
 =====================
 http://linuxwireless.org/en/users/Drivers/brcm80211
-- 
1.7.4.1


