Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:44846 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754482AbXD2Aec (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 20:34:32 -0400
Received: from logostar.upir.cz (r2u241.net.upc.cz [62.245.84.241])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.suse.cz (SUSE LINUX ESMTP Mailer) with ESMTP id 05FCA628062
	for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2007 02:34:30 +0200 (CEST)
Date: Sun, 29 Apr 2007 02:34:29 +0200
From: Jiri Benc <jbenc@suse.cz>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: add copyrights
Message-ID: <20070429023429.5bca2c6a@logostar.upir.cz>
In-Reply-To: <20070429023215.40c2aea7@logostar.upir.cz>
References: <20070429023215.40c2aea7@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have been lazy with adding my copyright to some files.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 include/net/mac80211.h       |    1 +
 net/mac80211/ieee80211.c     |    1 +
 net/mac80211/ieee80211_i.h   |    1 +
 net/mac80211/ieee80211_sta.c |    1 +
 net/mac80211/sta_info.c      |    1 +
 5 files changed, 5 insertions(+)

--- dscape.orig/include/net/mac80211.h
+++ dscape/include/net/mac80211.h
@@ -1,6 +1,7 @@
 /*
  * Low-level hardware driver -- IEEE 802.11 driver (80211.o) interface
  * Copyright 2002-2005, Devicescape Software, Inc.
+ * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
--- dscape.orig/net/mac80211/ieee80211.c
+++ dscape/net/mac80211/ieee80211.c
@@ -1,6 +1,7 @@
 /*
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005-2006, Devicescape Software, Inc.
+ * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
--- dscape.orig/net/mac80211/ieee80211_i.h
+++ dscape/net/mac80211/ieee80211_i.h
@@ -1,6 +1,7 @@
 /*
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005, Devicescape Software, Inc.
+ * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
--- dscape.orig/net/mac80211/ieee80211_sta.c
+++ dscape/net/mac80211/ieee80211_sta.c
@@ -3,6 +3,7 @@
  * Copyright 2003, Jouni Malinen <jkmaline@cc.hut.fi>
  * Copyright 2004, Instant802 Networks, Inc.
  * Copyright 2005, Devicescape Software, Inc.
+ * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  *
  * This program is free software; you can redistribute it and/or modify
--- dscape.orig/net/mac80211/sta_info.c
+++ dscape/net/mac80211/sta_info.c
@@ -1,5 +1,6 @@
 /*
  * Copyright 2002-2005, Instant802 Networks, Inc.
+ * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
