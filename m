Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36265 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0KJCVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:32 -0500
Received: by mail-qy0-f181.google.com with SMTP id 31so159944qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:32 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 27/44] compat/2.6.33: remove macro not in mainline
Date: Tue,  9 Nov 2010 21:20:09 -0500
Message-Id: <1289355626-25373-28-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.23.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/compat-2.6.23.h b/include/linux/compat-2.6.23.h
index 5dd6301..1a486ab 100644
--- a/include/linux/compat-2.6.23.h
+++ b/include/linux/compat-2.6.23.h
@@ -84,10 +84,6 @@ static inline void tcf_destroy_chain_compat(struct tcf_proto **fl)
 #define da_users	dmi_users
 #define da_gusers	dmi_gusers
 
-/* dev_set_promiscuity() was moved to __dev_set_promiscuity() on 2.6.23 and
- * dev_set_promiscuity() became a wrapper. */
-#define __dev_set_promiscuity dev_set_promiscuity
-
 /* Our own 2.6.22 port on compat.c */
 extern void	dev_mc_unsync(struct net_device *to, struct net_device *from);
 extern int	dev_mc_sync(struct net_device *to, struct net_device *from);
-- 
1.7.2.30.gc37d7.dirty

