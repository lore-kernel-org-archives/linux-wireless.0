Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37711 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503Ab1JAKdf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 06:33:35 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: make patches apply again
Date: Sat,  1 Oct 2011 12:33:18 +0200
Message-Id: <1317465198-2733-1-git-send-email-hauke@hauke-m.de> (sfid-20111001_123338_095136_993D2E5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/06-header-changes.patch |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/patches/06-header-changes.patch b/patches/06-header-changes.patch
index 9a2041f..d90fb06 100644
--- a/patches/06-header-changes.patch
+++ b/patches/06-header-changes.patch
@@ -23,9 +23,9 @@ cases.
  
  #include <linux/ip.h>
 +#include <linux/in.h>
+ #include <linux/module.h>
  #include "wifi.h"
  #include "rc.h"
- #include "base.h"
 --- a/drivers/net/wireless/wl1251/main.c
 +++ b/drivers/net/wireless/wl1251/main.c
 @@ -24,6 +24,9 @@
@@ -52,7 +52,7 @@ cases.
  
 --- a/net/mac80211/key.c
 +++ b/net/mac80211/key.c
-@@ -22,6 +22,9 @@
+@@ -23,6 +23,9 @@
  #include "aes_ccm.h"
  #include "aes_cmac.h"
  
-- 
1.7.4.1

