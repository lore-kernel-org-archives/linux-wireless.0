Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:2356 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752373Ab0EKIjP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 04:39:15 -0400
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0302657154
	for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 17:39:14 +0900 (JST)
Subject: [RFC PATCH 1/3] iw: fix makefile for cqm
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Date: Tue, 11 May 2010 17:39:33 +0900
Message-ID: <20100511083933.28347.37155.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index e21900a..d303f45 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,7 @@ CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
 OBJS = iw.o genl.o event.o info.o phy.o \
 	interface.o ibss.o station.o survey.o util.o \
 	mesh.o mpath.o scan.o reg.o version.o \
-	reason.o status.o connect.o link.o offch.o ps.o cqm.c
+	reason.o status.o connect.o link.o offch.o ps.o cqm.o
 OBJS += sections.o
 ALL = iw
 

