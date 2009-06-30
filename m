Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP02.calltower.com ([69.4.184.249]:35672 "EHLO
	L01SLCSMTP02.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753166AbZF3VS4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 17:18:56 -0400
Subject: [PATCH 1/5] Allow .config to supply optional local Makefile
 settings.
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 16:18:59 -0500
Message-Id: <1246396739.13176.258.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jon Loeliger <jdl@bigfootnetworks.com>
---
 Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index b93b735..589c453 100644
--- a/Makefile
+++ b/Makefile
@@ -1,3 +1,5 @@
+-include .config
+
 # Modify as you see fit, note this is built into crda,
 # so if you change it here you will have to change crda.c
 REG_BIN?=/usr/lib/crda/regulatory.bin
-- 
1.6.3.GIT



