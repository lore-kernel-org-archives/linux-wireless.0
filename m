Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2820 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab1HHN7b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:31 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 82/82] staging: brcm80211: updated TODO file
Date: Mon, 8 Aug 2011 15:59:06 +0200
Message-ID: <1312811946-16713-83-git-send-email-arend@broadcom.com> (sfid-20110808_160135_015686_1898488A)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only remaining TODO item has been tackled so it was removed. No
other TODO items left.

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


