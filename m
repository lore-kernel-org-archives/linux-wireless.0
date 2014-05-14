Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0007.hostedemail.com ([216.40.44.7]:50063 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752725AbaENTPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 15:15:25 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] wlcore: Remove trailing semicolon from do {...} while (0) macro
Date: Wed, 14 May 2014 12:15:14 -0700
Message-Id: <a62dbcaa8438b3ee6cdf94d7681427c6f48f122a.1400094804.git.joe@perches.com> (sfid-20140514_211609_058010_7F298304)
In-Reply-To: <cover.1400094804.git.joe@perches.com>
References: <cover.1400094804.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These should not have trailing semicolons so remove them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.h b/drivers/net/wireless/ti/wlcore/debugfs.h
index f7381dd..0f2cfb0 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.h
+++ b/drivers/net/wireless/ti/wlcore/debugfs.h
@@ -57,7 +57,7 @@ static const struct file_operations name## _ops = {			\
 					    wl, &name## _ops);		\
 		if (!entry || IS_ERR(entry))				\
 			goto err;					\
-	} while (0);
+	} while (0)
 
 
 #define DEBUGFS_ADD_PREFIX(prefix, name, parent)			\
@@ -66,7 +66,7 @@ static const struct file_operations name## _ops = {			\
 				    wl, &prefix## _## name## _ops);	\
 		if (!entry || IS_ERR(entry))				\
 			goto err;					\
-	} while (0);
+	} while (0)
 
 #define DEBUGFS_FWSTATS_FILE(sub, name, fmt, struct_type)		\
 static ssize_t sub## _ ##name## _read(struct file *file,		\
-- 
1.8.1.2.459.gbcd45b4.dirty

