Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54204 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbZGGJKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 05:10:11 -0400
Subject: [PATCH] mac80211: fix docbook
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 11:10:12 +0200
Message-Id: <1246957812.4755.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two functions no longer exist in mac80211,
so trying to insert them generates warnings in
the document.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 Documentation/DocBook/mac80211.tmpl |    2 --
 1 file changed, 2 deletions(-)

--- wireless-testing.orig/Documentation/DocBook/mac80211.tmpl	2009-07-07 11:07:50.000000000 +0200
+++ wireless-testing/Documentation/DocBook/mac80211.tmpl	2009-07-07 11:08:15.000000000 +0200
@@ -184,8 +184,6 @@ usage should require reading the full do
 !Finclude/net/mac80211.h ieee80211_ctstoself_get
 !Finclude/net/mac80211.h ieee80211_ctstoself_duration
 !Finclude/net/mac80211.h ieee80211_generic_frame_duration
-!Finclude/net/mac80211.h ieee80211_get_hdrlen_from_skb
-!Finclude/net/mac80211.h ieee80211_hdrlen
 !Finclude/net/mac80211.h ieee80211_wake_queue
 !Finclude/net/mac80211.h ieee80211_stop_queue
 !Finclude/net/mac80211.h ieee80211_wake_queues


