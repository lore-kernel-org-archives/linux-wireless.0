Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65142 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab0KJCVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:11 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5749qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:10 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 15/44] compat/2.6.25: add compat macro for ip_route_output_key()
Date: Tue,  9 Nov 2010 21:19:57 -0500
Message-Id: <1289355626-25373-16-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is was a late network namespace conversion :)

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.25.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.25.h b/include/linux/compat-2.6.25.h
index b2bf50f..4d55bbb 100644
--- a/include/linux/compat-2.6.25.h
+++ b/include/linux/compat-2.6.25.h
@@ -88,6 +88,8 @@ extern void		__dev_addr_unsync(struct dev_addr_list **to, int *to_count, struct
 
 #define seq_file_net &init_net;
 
+#define ip_route_output_key(net, rt, fl)	ip_route_output_key(rt, fl)
+
 enum nf_inet_hooks {
 	NF_INET_PRE_ROUTING = 0,
 	NF_INET_LOCAL_IN = 1,
-- 
1.7.2.30.gc37d7.dirty

