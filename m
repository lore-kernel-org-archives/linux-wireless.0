Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:62802 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329AbXKGI3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 03:29:41 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1938337nfb
        for <linux-wireless@vger.kernel.org>; Wed, 07 Nov 2007 00:29:40 -0800 (PST)
Message-ID: <47317771.406@gmail.com> (sfid-20071107_082947_928000_E146F891)
Date: Wed, 07 Nov 2007 09:29:37 +0100
From: Jiri Olsa <olsajiri@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: netdev@vger.kernel.org
Subject: [PATCH] net: Removing duplicit #includes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing duplicit #includes for net/
Signed-off-by: Jiri Olsa <olsajiri@gmail.com> 
---
 net/core/dst.c                       |    1 -
 net/ieee80211/ieee80211_crypt_tkip.c |    1 -
 net/ieee80211/ieee80211_crypt_wep.c  |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/core/dst.c b/net/core/dst.c
index 16958e6..03daead 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -18,7 +18,6 @@
 #include <linux/types.h>
 #include <net/net_namespace.h>
 
-#include <net/net_namespace.h>
 #include <net/dst.h>
 
 /*
diff --git a/net/ieee80211/ieee80211_crypt_tkip.c b/net/ieee80211/ieee80211_crypt_tkip.c
index 4cce353..58b2261 100644
--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/ieee80211/ieee80211_crypt_tkip.c
@@ -25,7 +25,6 @@
 #include <net/ieee80211.h>
 
 #include <linux/crypto.h>
-#include <linux/scatterlist.h>
 #include <linux/crc32.h>
 
 MODULE_AUTHOR("Jouni Malinen");
diff --git a/net/ieee80211/ieee80211_crypt_wep.c b/net/ieee80211/ieee80211_crypt_wep.c
index 866fc04..3fa30c4 100644
--- a/net/ieee80211/ieee80211_crypt_wep.c
+++ b/net/ieee80211/ieee80211_crypt_wep.c
@@ -22,7 +22,6 @@
 #include <net/ieee80211.h>
 
 #include <linux/crypto.h>
-#include <linux/scatterlist.h>
 #include <linux/crc32.h>
 
 MODULE_AUTHOR("Jouni Malinen");
