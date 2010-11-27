Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33249 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab0K0GWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Nov 2010 01:22:04 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 6/9]drivers:char:nvram.c Change the copyright info.
Date: Fri, 26 Nov 2010 22:21:16 -0800
Message-Id: <1290838879-11038-7-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
References: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the copyright info from Sun Microsystems to Oracle since Oracle now owns them.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/char/nvram.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 166f1e7..33e8faa 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 1997 Roman Hodek <Roman.Hodek@informatik.uni-erlangen.de>
  * idea by and with help from Richard Jelinek <rj@suse.de>
- * Portions copyright (c) 2001,2002 Sun Microsystems (thockin@sun.com)
+ * Portions copyright (c) 2001,2002 Oracle and/or its affiliates. (thockin@sun.com)
  *
  * This driver allows you to access the contents of the non-volatile memory in
  * the mc146818rtc.h real-time clock. This chip is built into all PCs and into
-- 
1.7.1

