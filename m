Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40353 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1DTVf0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 17:35:26 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: make patches apply again
Date: Wed, 20 Apr 2011 23:35:10 +0200
Message-Id: <1303335312-6970-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/03-rfkill.patch |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/patches/03-rfkill.patch b/patches/03-rfkill.patch
index a46bdf6..051c6f0 100644
--- a/patches/03-rfkill.patch
+++ b/patches/03-rfkill.patch
@@ -30,7 +30,7 @@ This would do the policing from within mac80211.
 
 --- a/net/rfkill/Makefile
 +++ b/net/rfkill/Makefile
-@@ -2,6 +2,6 @@
+@@ -2,7 +2,7 @@
  # Makefile for the RF switch subsystem.
  #
  
@@ -40,6 +40,7 @@ This would do the policing from within mac80211.
 +rfkill_backport-y			+= core.o
 +rfkill_backport-$(CONFIG_RFKILL_BACKPORT_INPUT)	+= input.o
 +obj-$(CONFIG_RFKILL_BACKPORT)		+= rfkill_backport.o
+ obj-$(CONFIG_RFKILL_REGULATOR)	+= rfkill-regulator.o
 --- a/net/rfkill/input.c
 +++ b/net/rfkill/input.c
 @@ -232,7 +232,7 @@ static int rfkill_connect(struct input_h
-- 
1.7.1

