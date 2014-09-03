Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:65370 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbaICMcn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:32:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/10] cfg80211: add Intel Mobile Communications copyright
Date: Wed,  3 Sep 2014 15:24:58 +0300
Message-Id: <1409747106-30717-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140903_143248_798959_94AA7F38)
In-Reply-To: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Our legal structure changed at some point (see wikipedia), but
we forgot to immediately switch over to the new copyright
notice.

For files that we have modified in the time since the change,
add the proper copyright notice now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/linux/ieee80211.h | 1 +
 include/net/cfg80211.h    | 1 +
 net/wireless/chan.c       | 1 +
 net/wireless/core.c       | 1 +
 net/wireless/nl80211.c    | 1 +
 net/wireless/reg.c        | 1 +
 net/wireless/scan.c       | 1 +
 net/wireless/util.c       | 1 +
 8 files changed, 8 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 63ab3873..91d59d6 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -6,6 +6,7 @@
  * Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
  * Copyright (c) 2005, Devicescape Software, Inc.
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
+ * Copyright (c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0a080c4..42a990c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4,6 +4,7 @@
  * 802.11 device and configuration interface
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 992b340..72d81e2 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -4,6 +4,7 @@
  * any point in time.
  *
  * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  */
 
 #include <linux/export.h>
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 682babd..b32f85c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -2,6 +2,7 @@
  * This is the linux wireless configuration interface.
  *
  * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index df7b133..23f5ee7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2,6 +2,7 @@
  * This is the new netlink-based wireless configuration interface.
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  */
 
 #include <linux/if.h>
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1afdf45..8bfc9b1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3,6 +3,7 @@
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2008-2011	Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 0798c62..f74b61e 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2,6 +2,7 @@
  * cfg80211 scan result handling
  *
  * Copyright 2008 Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  */
 #include <linux/kernel.h>
 #include <linux/slab.h>
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 728f1c0..a8b2816 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -2,6 +2,7 @@
  * Wireless utility functions
  *
  * Copyright 2007-2009	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  */
 #include <linux/export.h>
 #include <linux/bitops.h>
-- 
1.9.1

