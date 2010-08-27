Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab0H0J31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 05:29:27 -0400
Subject: [PATCH] cfg80211 docbook: remove erronous !A
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 11:29:24 +0200
Message-ID: <1282901364.4377.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My previous patch erroneously included an
!A line (for some checking I am working on)
that isn't yet supported by the docbook
tools, so remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |    1 -
 1 file changed, 1 deletion(-)

--- wireless-testing.orig/Documentation/DocBook/80211.tmpl	2010-08-27 11:27:50.000000000 +0200
+++ wireless-testing/Documentation/DocBook/80211.tmpl	2010-08-27 11:27:54.000000000 +0200
@@ -65,7 +65,6 @@
     </abstract>
   </setinfo>
   <book id="cfg80211-developers-guide">
-!Ainclude/net/cfg80211.h
     <bookinfo>
       <title>The cfg80211 subsystem</title>
 


