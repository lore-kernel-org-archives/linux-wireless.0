Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42946 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932275AbdCaHQg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 03:16:36 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] cfg80211: add remaining functions/etc. to documentation
Date: Fri, 31 Mar 2017 09:16:32 +0200
Message-Id: <20170331071632.6209-2-johannes@sipsolutions.net> (sfid-20170331_091640_666393_AFE0730E)
In-Reply-To: <20170331071632.6209-1-johannes@sipsolutions.net>
References: <20170331071632.6209-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A lot (likely most!) enums, structs and functions aren't explicitly
listed in the documentation. For now, just add everything to the
documentation in a new section so at least the references to those
functions can be resolved.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/driver-api/80211/cfg80211.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/driver-api/80211/cfg80211.rst b/Documentation/driver-api/80211/cfg80211.rst
index 8ffac57e1f5b..52caec2c9ff9 100644
--- a/Documentation/driver-api/80211/cfg80211.rst
+++ b/Documentation/driver-api/80211/cfg80211.rst
@@ -355,3 +355,8 @@ Test mode
 
 .. kernel-doc:: include/net/cfg80211.h
    :functions: cfg80211_testmode_event
+
+Remaining functions
+===================
+.. kernel-doc:: include/net/cfg80211.h
+   :unused-functions:
-- 
2.11.0
