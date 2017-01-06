Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34856 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965020AbdAFPU4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 10:20:56 -0500
Date: Fri, 6 Jan 2017 20:50:43 +0530
From: Rahul Krishnan <mrahul.krishnan@gmail.com>
To: m@bues.ch
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ssb: main.c: This patch removes unnecessary return statement
 using spatch tool
Message-ID: <20170106152043.GA6383@rahul> (sfid-20170106_162133_391494_74B474AD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary return statement using spatch.
Signed-off-by: Rahul Krishnan <mrahul.krishnan@gmail.com>
---
 drivers/ssb/main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index d1a7507..ae3b7fe 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1,4 +1,4 @@
-/*
+ patch /home/rahul/git/kernels/staging/drivers//*
  * Sonics Silicon Backplane
  * Subsystem core
  *
@@ -1272,9 +1272,7 @@ u32 ssb_admatch_size(u32 adm)
 	default:
 		SSB_WARN_ON(1);
 	}
-	size = (1 << (size + 1));
-
-	return size;
+	return (1 << (size + 1));
 }
 EXPORT_SYMBOL(ssb_admatch_size);
 
-- 
2.7.4
