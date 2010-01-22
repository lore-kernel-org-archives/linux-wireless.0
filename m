Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:40113 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605Ab0AVXfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 18:35:36 -0500
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/6] Rearrange the help text for block & unblock.
Date: Fri, 22 Jan 2010 23:35:26 +0000
Message-Id: <1264203330-20785-2-git-send-email-linux@youmustbejoking.demon.co.uk>
In-Reply-To: <1264203330-20785-1-git-send-email-linux@youmustbejoking.demon.co.uk>
References: <1264203330-20785-1-git-send-email-linux@youmustbejoking.demon.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 rfkill.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/rfkill.c b/rfkill.c
index 7b44b5a..3cb2605 100644
--- a/rfkill.c
+++ b/rfkill.c
@@ -224,8 +224,6 @@ static enum rfkill_type rfkill_str_to_type(char *s)
 
 static const char *argv0;
 
-#define BLOCK_PARAMS "{<idx>,all,wifi,wlan,bluetooth,uwb,ultrawideband,wimax,wwan,gps}"
-
 static void usage(void)
 {
 	fprintf(stderr, "Usage:\t%s [options] command\n", argv0);
@@ -235,8 +233,10 @@ static void usage(void)
 	fprintf(stderr, "\thelp\n");
 	fprintf(stderr, "\tevent\n");
 	fprintf(stderr, "\tlist\n");
-	fprintf(stderr, "\tblock "BLOCK_PARAMS"\n");
-	fprintf(stderr, "\tunblock "BLOCK_PARAMS"\n");
+	fprintf(stderr, "\tblock IDENTIFIER\n");
+	fprintf(stderr, "\tunblock IDENTIFIER\n");
+	fprintf(stderr, "where IDENTIFIER is the index no. of an rfkill switch or one of:\n");
+	fprintf(stderr, "\t<idx> all wifi wlan bluetooth uwb ultrawideband wimax wwan gps\n");
 }
 
 static void version(void)
-- 
1.6.5

