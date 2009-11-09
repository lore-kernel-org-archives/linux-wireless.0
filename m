Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46271 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbZKIXrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:47:46 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so3717715ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 15:47:51 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH v2 20/20] mac80211: update copyrights to 2009
Date: Mon,  9 Nov 2009 23:46:58 +0000
Message-Id: <1257810418-30075-21-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/mesh.c         |    2 +-
 net/mac80211/mesh.h         |    2 +-
 net/mac80211/mesh_hwmp.c    |    2 +-
 net/mac80211/mesh_pathtbl.c |    2 +-
 net/mac80211/mesh_plink.c   |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 05955dc..bbd56b0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 open80211s Ltd.
+ * Copyright (c) 2008, 2009 open80211s Ltd.
  * Authors:    Luis Carlos Cobo <luisca@cozybit.com>
  * 	       Javier Cardona <javier@cozybit.com>
  *
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 5ad6975..bd0e1cb 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 open80211s Ltd.
+ * Copyright (c) 2008, 2009 open80211s Ltd.
  * Authors:    Luis Carlos Cobo <luisca@cozybit.com>
  *             Javier Cardona <javier@cozybit.com>
  *
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 54c3f58..1f2ad0a 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 open80211s Ltd.
+ * Copyright (c) 2008, 2009 open80211s Ltd.
  * Author:     Luis Carlos Cobo <luisca@cozybit.com>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 2cebdf5..5399e7a 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 open80211s Ltd.
+ * Copyright (c) 2008, 2009 open80211s Ltd.
  * Author:     Luis Carlos Cobo <luisca@cozybit.com>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index ec68d20..f21329a 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 open80211s Ltd.
+ * Copyright (c) 2008, 2009 open80211s Ltd.
  * Author:     Luis Carlos Cobo <luisca@cozybit.com>
  *
  * This program is free software; you can redistribute it and/or modify
-- 
1.5.6.5

