Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:38944 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab0LUPYS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 10:24:18 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.neratec.ch (Postfix) with ESMTP id 02A7B664004
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 16:15:19 +0100 (CET)
Received: from mail.neratec.ch ([127.0.0.1])
	by localhost (mail.neratec.ch [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3cBdBb69XSOb for <linux-wireless@vger.kernel.org>;
	Tue, 21 Dec 2010 16:15:18 +0100 (CET)
Received: from mail.neratec.ch (mail.neratec.ch [192.168.11.23])
	by mail.neratec.ch (Postfix) with ESMTP id 4EC4C664003
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 16:15:18 +0100 (CET)
Date: Tue, 21 Dec 2010 16:15:18 +0100 (CET)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Message-ID: <563603787.11114.1292944518290.JavaMail.root@idefix>
In-Reply-To: <902496335.11104.1292944273242.JavaMail.root@idefix>
Subject: [PATCH 4/4] DFS: added license info to new files
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 include/net/dfs.h       |    4 ++--
 .../net/wireless/dfs/dfs_handler.c                 |    8 ++++++++
 .../net/wireless/dfs/dfs_pattern_detector.c        |    8 ++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/net/dfs.h b/include/net/dfs.h
index 1dccc10..0744502 100644
--- a/include/net/dfs.h
+++ b/include/net/dfs.h
@@ -48,10 +48,10 @@ enum channel_dfs_flags {
 /**
  * struct pulse_event - events fed to the dfs handler
  *
- * @ts: absolute time stamp for start of pulse in us (e.g. as TSF)
+ * @ts: absolute time stamp for start of pulse in [us] (e.g. as TSF)
  * @freq: channel frequency in [MHz]
  * @rssi: rssi value for the given pulse
- * @width: pulse width for given pulse in [us]
+ * @width: pulse width in [us]
  *
  */
 struct pulse_event {
diff --git a/net/wireless/dfs/dfs_handler.c b/net/wireless/dfs/dfs_handler.c
index 7e65852..952eb97 100644
--- a/net/wireless/dfs/dfs_handler.c
+++ b/net/wireless/dfs/dfs_handler.c
@@ -1,3 +1,11 @@
+/*
+ * Copyright 2010, Neratec Solutions AG, <zefir.kurtisi@neratec.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include "net/dfs.h"
 #include "net/cfg80211.h"
 #include "dfs_common.h"
diff --git a/net/wireless/dfs/dfs_pattern_detector.c b/net/wireless/dfs/dfs_pattern_detector.c
index 17ab7d6..513cc91 100644
--- a/net/wireless/dfs/dfs_pattern_detector.c
+++ b/net/wireless/dfs/dfs_pattern_detector.c
@@ -1,3 +1,11 @@
+/*
+ * Copyright 2010, Neratec Solutions AG, <zefir.kurtisi@neratec.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include "dfs_pattern_detector.h"
 #include "dfs_debug.h"
 #include "net/dfs.h"
-- 
1.5.4.3
