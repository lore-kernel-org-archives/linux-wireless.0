Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50196 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1FIPeb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 11:34:31 -0400
Received: by wya21 with SMTP id 21so1213895wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jun 2011 08:34:30 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] compat: define create_freezable_workqueue
Date: Thu,  9 Jun 2011 18:35:03 +0300
Message-Id: <1307633703-1279-1-git-send-email-eliad@wizery.com> (sfid-20110609_173435_867300_A7A19C94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

create_freezeable_workqueue() was renamed to
create_freezable_workqueue().

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/linux/compat-2.6.38.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
index 004fe27..2dd1910 100644
--- a/include/linux/compat-2.6.38.h
+++ b/include/linux/compat-2.6.38.h
@@ -39,6 +39,7 @@ static inline unsigned long ewma_read(const struct ewma *avg)
 }
 
 #define pr_warn pr_warning
+#define create_freezable_workqueue create_freezeable_workqueue
 
 static inline int skb_checksum_start_offset(const struct sk_buff *skb)
 {
-- 
1.7.0.4

