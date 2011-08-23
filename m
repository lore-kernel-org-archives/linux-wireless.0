Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49515 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1HWWDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 18:03:37 -0400
Received: by gwaa12 with SMTP id a12so446302gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 15:03:36 -0700 (PDT)
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH] wireless: relicense regulatory header to ISC
Date: Tue, 23 Aug 2011 15:03:34 -0700
Message-Id: <1314137014-31862-1-git-send-email-lrodriguez@qca.qualcomm.com> (sfid-20110824_000340_949196_7414F092)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

I will suck out stuff to userspace to start the regulatory
revampamp, this work will be permissively licensed.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 include/net/regulatory.h |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 356d6e3..eb7d3c2 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -3,11 +3,19 @@
 /*
  * regulatory support structures
  *
- * Copyright 2008-2009	Luis R. Rodriguez <lrodriguez@atheros.com>
+ * Copyright 2008-2009	Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
 
-- 
1.7.4.15.g7811d

