Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:41021 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3EaCMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:12:08 -0400
Received: by mail-pd0-f181.google.com with SMTP id bv13so1374329pdb.26
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:12:07 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 33/40] crda: fix spacing on reglib_for_each_country()
Date: Thu, 30 May 2013 19:09:22 -0700
Message-Id: <1369966169-23640-34-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042938_659678_04CA415C)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/reglib.h b/reglib.h
index 8a31e0d..d89fcd5 100644
--- a/reglib.h
+++ b/reglib.h
@@ -76,9 +76,9 @@ int reglib_verify_db_signature(uint8_t *db, int dblen, int siglen);
 const struct ieee80211_regdomain *
 reglib_get_rd_idx(unsigned int idx, const char *file);
 
-#define reglib_for_each_country(__rd, __idx, __file)			\
+#define reglib_for_each_country(__rd, __idx, __file)		\
 	for (__rd = reglib_get_rd_idx(__idx, __file);		\
-	     __rd != NULL;						\
+	     __rd != NULL;					\
 	     __rd = reglib_get_rd_idx(++__idx, __file))		\
 
 const struct ieee80211_regdomain *
-- 
1.7.10.4

