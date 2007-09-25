Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:36526 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbXIYSok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 14:44:40 -0400
Received: by mu-out-0910.google.com with SMTP id i10so3341065mue
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 11:44:39 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/12] rt2x00: Correctly identify rt2561turbo
Date: Tue, 25 Sep 2007 20:54:44 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709252052.34803.IvDoorn@gmail.com>
In-Reply-To: <200709252052.34803.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709252054.44475.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apparently rt2561s actually has PCI ID 0x0301
and rt2561 actually has PCI ID 0x0302.
Where rt2561s supports Turbo.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 80b079d..2609d4a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -159,8 +159,8 @@ struct rt2x00_chip {
 #define RT2460		0x0101
 #define RT2560		0x0201
 #define RT2570		0x1201
-#define RT2561		0x0301
-#define RT2561s		0x0302
+#define RT2561s		0x0301	/* Turbo */
+#define RT2561		0x0302
 #define RT2661		0x0401
 #define RT2571		0x1300
 
-- 
1.5.3.2

