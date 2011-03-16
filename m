Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34425 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1CPJgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 05:36:31 -0400
From: Greg Whiteley <greg.whiteley@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Greg Whiteley <greg.whiteley@gmail.com>
Subject: [PATCH] compat-wireless: rt2800pci (and rt2x00pci) don't unload on 'make wlunload'
Date: Wed, 16 Mar 2011 20:36:08 +1100
Message-Id: <1300268168-25420-1-git-send-email-greg.whiteley@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add missing module names to scripts/wlunload.sh as followup to review-comment
by Walter Goldens for commit f77cb6ccc803ff679c377914fd60ff9a268c6f14

Signed-off-by: Greg Whiteley <greg.whiteley@gmail.com>
---
 scripts/wlunload.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/wlunload.sh b/scripts/wlunload.sh
index cd6298d..5860c0d 100755
--- a/scripts/wlunload.sh
+++ b/scripts/wlunload.sh
@@ -21,8 +21,8 @@ MODULES="$MODULES ath5k ath ath6kl ar9170usb carl9170"
 MODULES="$MODULES p54pci p54usb p54spi p54common"
 MODULES="$MODULES rt2400pci rt2500pci rt61pci"
 MODULES="$MODULES rt2500usb rt73usb"
-MODULES="$MODULES rt2800usb rt2800lib"
-MODULES="$MODULES rt2x00usb rt2x00lib"
+MODULES="$MODULES rt2800usb rt2800pci rt2800lib"
+MODULES="$MODULES rt2x00usb rt2x00pci rt2x00lib"
 MODULES="$MODULES rtl8180 rtl8187 rtl8192ce rtlwifi"
 MODULES="$MODULES mwl8k mac80211_hwsim"
 MODULES="$MODULES at76c50x_usb at76_usb"
-- 
1.7.0.4

