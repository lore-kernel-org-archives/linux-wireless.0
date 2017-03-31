Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42938 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbdCaHQC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 03:16:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] cfg80211: add intro to documentation
Date: Fri, 31 Mar 2017 09:15:56 +0200
Message-Id: <20170331071556.6121-2-johannes@sipsolutions.net> (sfid-20170331_091610_281232_ADD42457)
In-Reply-To: <20170331071556.6121-1-johannes@sipsolutions.net>
References: <20170331071556.6121-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This introduction section should be used in the documentation,
do that at the beginning of the cfg80211 chapter.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/driver-api/80211/cfg80211.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/driver-api/80211/cfg80211.rst b/Documentation/driver-api/80211/cfg80211.rst
index b101bc0c195b..8ffac57e1f5b 100644
--- a/Documentation/driver-api/80211/cfg80211.rst
+++ b/Documentation/driver-api/80211/cfg80211.rst
@@ -2,6 +2,9 @@
 cfg80211 subsystem
 ==================
 
+.. kernel-doc:: include/net/cfg80211.h
+   :doc: Introduction
+
 Device registration
 ===================
 
-- 
2.11.0
