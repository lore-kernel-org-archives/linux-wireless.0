Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0LAIoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 03:44:44 -0500
Message-Id: <20101201084348.767508881@sipsolutions.net>
Date: Wed, 01 Dec 2010 09:43:33 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/9] mac80211: publish interface iteration docs
References: <20101201084326.410001080@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Publish the documentation for the interface
iteration functions in the right section of
the book.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:19.000000000 +0100
+++ wireless-testing/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:19.000000000 +0100
@@ -435,6 +435,8 @@
           supported by mac80211, add notes about supporting hw crypto
           with it.
         </para>
+!Finclude/net/mac80211.h ieee80211_iterate_active_interfaces
+!Finclude/net/mac80211.h ieee80211_iterate_active_interfaces_atomic
       </chapter>
 
       <chapter id="hardware-scan-offload">


