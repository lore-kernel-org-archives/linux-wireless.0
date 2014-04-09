Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40028 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaDIB3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 21:29:01 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so1762174pdi.33
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 18:29:00 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 6/8] mac80211: remove unnecessary include clauses (mac80211.h)
Date: Wed,  9 Apr 2014 09:28:11 +0800
Message-Id: <1ba53edc82eb5d3019c04079b192535863d4c441.1397006688.git.gamerh2o@gmail.com> (sfid-20140409_032907_361710_DFF92100)
In-Reply-To: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
In-Reply-To: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<linux/bug.h>, <linux/kernel.h>, <linux/if_ether.h>, <linux/skbuff.h>
and <linux/ieee80211.h> are all directly or indirectly included by
<net/cfg80211.h>.

So just remove them.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 include/net/mac80211.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 604e279..7d7d828 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -13,11 +13,6 @@
 #ifndef MAC80211_H
 #define MAC80211_H
 
-#include <linux/bug.h>
-#include <linux/kernel.h>
-#include <linux/if_ether.h>
-#include <linux/skbuff.h>
-#include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 #include <asm/unaligned.h>
 
-- 
1.9.0

