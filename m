Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:47904 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbaICMcn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:32:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/10] mac80211: add Intel Mobile Communications copyright
Date: Wed,  3 Sep 2014 15:24:57 +0300
Message-Id: <1409747106-30717-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140903_143301_333165_E255EFAD)
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
 include/net/mac80211.h     | 1 +
 net/mac80211/cfg.c         | 1 +
 net/mac80211/debugfs.c     | 1 +
 net/mac80211/debugfs_sta.c | 1 +
 net/mac80211/ibss.c        | 1 +
 net/mac80211/ieee80211_i.h | 1 +
 net/mac80211/iface.c       | 1 +
 net/mac80211/key.c         | 1 +
 net/mac80211/main.c        | 1 +
 net/mac80211/mlme.c        | 1 +
 net/mac80211/rx.c          | 1 +
 net/mac80211/scan.c        | 1 +
 net/mac80211/sta_info.c    | 1 +
 net/mac80211/sta_info.h    | 1 +
 net/mac80211/status.c      | 1 +
 net/mac80211/tdls.c        | 1 +
 net/mac80211/tx.c          | 1 +
 net/mac80211/util.c        | 1 +
 net/mac80211/wme.c         | 1 +
 19 files changed, 19 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dae2e24..dee3edd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4,6 +4,7 @@
  * Copyright 2002-2005, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 927b4ea..6cd0a59e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2,6 +2,7 @@
  * mac80211 configuration hooks for cfg80211
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This file is GPLv2 as found in COPYING.
  */
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 0e963bc..5746561 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -3,6 +3,7 @@
  * mac80211 debugfs for wireless PHYs
  *
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * GPLv2
  *
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 3db9664..619f00b 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -2,6 +2,7 @@
  * Copyright 2003-2005	Devicescape Software, Inc.
  * Copyright (c) 2006	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 9713dc5..5e0da74 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -6,6 +6,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2009, Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ef7a089..a0b89da 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -3,6 +3,7 @@
  * Copyright 2005, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 01eede7..3dc63aa 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -5,6 +5,7 @@
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright (c) 2006 Jiri Benc <jbenc@suse.cz>
  * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index d808cff..0102b30 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -3,6 +3,7 @@
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007-2008	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e0ab432..0de7c93 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -2,6 +2,7 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 31a8afa..2b38968 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5,6 +5,7 @@
  * Copyright 2005, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bd2c9b2..0479b70 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3,6 +3,7 @@
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index a0a9381..2d18652 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -6,6 +6,7 @@
  * Copyright 2005, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c6ee213..6274cd7 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1,6 +1,7 @@
 /*
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index d411bcc..edd6b88 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -1,5 +1,6 @@
 /*
  * Copyright 2002-2005, Devicescape Software, Inc.
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index aa06dca..2800e1c 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -3,6 +3,7 @@
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2008-2010	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 1b21050..32221fa 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2014, Intel Corporation
+ * Copyright 2014  Intel Mobile Communications GmbH
  *
  * This file is GPLv2 as found in COPYING.
  */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 464106c..6269a3e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3,6 +3,7 @@
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 725af7a..b444f27 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3,6 +3,7 @@
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index d51422c..af48119 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -1,5 +1,6 @@
 /*
  * Copyright 2004, Instant802 Networks, Inc.
+ * Copyright 2013-2014  Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
-- 
1.9.1

