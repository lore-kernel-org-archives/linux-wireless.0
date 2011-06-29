Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2003 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757604Ab1F2Xsm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 119/119] staging: brcm80211: updated TODO file
Date: Wed, 29 Jun 2011 16:48:23 -0700
Message-ID: <1309391303-22741-120-git-send-email-frankyl@broadcom.com> (sfid-20110630_014910_875407_C4BFE19D)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

Updated TODO file to reflect current driver state, results of recent
cleanup and fixes.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
---
 drivers/staging/brcm80211/TODO |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/brcm80211/TODO b/drivers/staging/brcm80211/TODO
index 94c792b..e2e2ef9 100644
--- a/drivers/staging/brcm80211/TODO
+++ b/drivers/staging/brcm80211/TODO
@@ -4,19 +4,9 @@ Bugs
 ====
 - none known at this moment
 
-brcmfmac and brcmsmac
-=====================
-- replace company specific acronym wlc_
-- Resolve all XXX, TODO, FIXME in code
-
 brcmfmac
 =====================
-- Remove unnecessary includes, move #includes from .h files into .c files.
-- Absorb and delete header files that are included in only one .c file
-- ASSERTS not allowed in mainline, replace by warning + error handling
-- Replace printk and WL_ERROR() with proper routines
-- Replace driver's proprietary ssb interface with generic kernel ssb module
-- Build and test on 64 bit linux kernel
+- ASSERTS deprecated in mainline, replace by warning + error handling
 
 brcm80211 info page
 =====================
-- 
1.7.1


