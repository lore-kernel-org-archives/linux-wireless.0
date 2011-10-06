Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41596 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935224Ab1JFQxK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 12:53:10 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: make patches apply again
Date: Thu,  6 Oct 2011 18:53:00 +0200
Message-Id: <1317919980-30865-1-git-send-email-hauke@hauke-m.de> (sfid-20111006_185313_945895_9BBDB8C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/35-fix-makefile-includes.patch |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/patches/35-fix-makefile-includes.patch b/patches/35-fix-makefile-includes.patch
index 17994b7..c9f8eb1 100644
--- a/patches/35-fix-makefile-includes.patch
+++ b/patches/35-fix-makefile-includes.patch
@@ -20,8 +20,8 @@ path the make process will search in the kernel tree for the headers.
 +ccflags-y += -I$(obj)/..
 --- a/drivers/staging/brcm80211/brcmfmac/Makefile
 +++ b/drivers/staging/brcm80211/brcmfmac/Makefile
-@@ -18,8 +18,8 @@
- ccflags-$(CONFIG_BRCMDBG)	+= -DSHOW_EVENTS
+@@ -16,8 +16,8 @@
+ # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  
  ccflags-y += \
 -	-Idrivers/staging/brcm80211/brcmfmac	\
@@ -33,10 +33,10 @@ path the make process will search in the kernel tree for the headers.
  	wl_cfg80211.o \
 --- a/drivers/staging/brcm80211/brcmsmac/Makefile
 +++ b/drivers/staging/brcm80211/brcmsmac/Makefile
-@@ -16,9 +16,9 @@
- # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+@@ -17,9 +17,9 @@
  
- ccflags-y :=				\
+ ccflags-y := \
+ 	-D__CHECK_ENDIAN__ \
 -	-Idrivers/staging/brcm80211/brcmsmac \
 -	-Idrivers/staging/brcm80211/brcmsmac/phy \
 -	-Idrivers/staging/brcm80211/include
-- 
1.7.4.1

