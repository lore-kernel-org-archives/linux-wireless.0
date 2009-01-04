Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:59046 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757972AbZADQfo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 11:35:44 -0500
Message-ID: <4960E55F.3040904@gmail.com> (sfid-20090104_173550_928129_2C366B04)
Date: Sun, 04 Jan 2009 17:35:43 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: solomon@linux-wlan.com, Greg KH <gregkh@suse.de>
CC: linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: ! has a higher precedence than &
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

! has a higher precedence than &

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I know checkpatch complains, but all whitespace in this file is like this

diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index 906ba43..c42cd7f 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -1580,7 +1580,7 @@ static int p80211wext_set_encodeext(struct net_device *dev,
 
 
   if ( ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY ) {
-    if ( ! ext->alg & IW_ENCODE_ALG_WEP) {
+    if (!(ext->alg & IW_ENCODE_ALG_WEP)) {
       WLAN_LOG_DEBUG(1,"asked to set a non wep key :(");
       return -EINVAL;
     }

