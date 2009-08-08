Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53660 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934065AbZHHMiX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 08:38:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/7] [compat-2.6] Add missing compat-2.6.*.c files
Date: Sat,  8 Aug 2009 14:38:11 +0200
Message-Id: <1249735096-27071-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
References: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/98-add-compat-wireless.patch |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/compat/patches/98-add-compat-wireless.patch b/compat/patches/98-add-compat-wireless.patch
index 1c7b39a..791bc6b 100644
--- a/compat/patches/98-add-compat-wireless.patch
+++ b/compat/patches/98-add-compat-wireless.patch
@@ -19,11 +19,16 @@ added compat.h also for ssb, I forget.
 
 --- a/net/wireless/Makefile	2009-08-07 12:27:50.836497001 -0700
 +++ b/net/wireless/Makefile	2009-08-07 12:27:51.952497240 -0700
-@@ -11,3 +11,11 @@
+@@ -11,3 +11,16 @@
  cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o wext-sme.o
  
  ccflags-y += -D__CHECK_ENDIAN__
 +# Compat-wireless kernel compatibility code
++cfg80211-y += compat-2.6.22.o
++cfg80211-y += compat-2.6.23.o
++cfg80211-y += compat-2.6.24.o
++cfg80211-y += compat-2.6.25.o
++cfg80211-y += compat-2.6.26.o
 +cfg80211-y += compat-2.6.27.o
 +cfg80211-y += compat-2.6.28.o
 +cfg80211-y += compat-2.6.29.o
-- 
1.6.2.1

