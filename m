Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4938 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758833Ab1FALqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:32 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 83/83] staging: brcm80211: updated TODO with current
 state of affairs
Date: Wed, 1 Jun 2011 13:46:08 +0200
Message-ID: <1306928768-7501-83-git-send-email-rvossen@broadcom.com> (sfid-20110601_134720_004738_03B2DEF5)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/TODO |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/TODO b/drivers/staging/brcm80211/TODO
index 2d9948d..94c792b 100644
--- a/drivers/staging/brcm80211/TODO
+++ b/drivers/staging/brcm80211/TODO
@@ -6,13 +6,13 @@ Bugs
 
 brcmfmac and brcmsmac
 =====================
-
-- Remove unnecessary includes, move #includes from .h files into .c files.
-- Absorb and delete header files that are included in only one .c file
+- replace company specific acronym wlc_
+- Resolve all XXX, TODO, FIXME in code
 
 brcmfmac
 =====================
-
+- Remove unnecessary includes, move #includes from .h files into .c files.
+- Absorb and delete header files that are included in only one .c file
 - ASSERTS not allowed in mainline, replace by warning + error handling
 - Replace printk and WL_ERROR() with proper routines
 - Replace driver's proprietary ssb interface with generic kernel ssb module
-- 
1.7.4.1


