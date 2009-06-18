Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:46235 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbZFRJhx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 05:37:53 -0400
Received: by ewy6 with SMTP id 6so1347484ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 02:37:54 -0700 (PDT)
Message-ID: <4A3A0AF0.9000000@tuffmail.co.uk>
Date: Thu, 18 Jun 2009 10:37:52 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] rfkill: fix comment
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 include/linux/rfkill.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index f3f6e2a..e73e242 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -261,7 +261,7 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked);
  *
  * In addition, it marks the device as "persistent", an attribute which
  * can be read by userspace.  Persistent devices are expected to preserve
- * preserve their own state when suspended.
+ * their own state when suspended.
  */
 void rfkill_init_sw_state(struct rfkill *rfkill, bool blocked);
 


