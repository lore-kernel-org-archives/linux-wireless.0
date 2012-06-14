Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63532 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378Ab2FNRxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 13:53:14 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so2190594wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 10:53:13 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 2/3] compat: Fix cosmetic typo in compat-3.4.c
Date: Thu, 14 Jun 2012 20:52:45 +0300
Message-Id: <1339696366-26970-2-git-send-email-ozancag@gmail.com> (sfid-20120614_195317_886758_FDC4C915)
In-Reply-To: <1339696366-26970-1-git-send-email-ozancag@gmail.com>
References: <1339696366-26970-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compat-3.4.c is for kernel version 3.4 not 3.5.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 compat/compat-3.4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/compat/compat-3.4.c b/compat/compat-3.4.c
index 5d516f0..4721fa2 100644
--- a/compat/compat-3.4.c
+++ b/compat/compat-3.4.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 3.5.
+ * Compatibility file for Linux wireless for kernels 3.4.
  */
 
 #include <linux/fs.h>
-- 
1.7.10.2

