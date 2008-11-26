Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10051 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYKZVDK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 16:03:10 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 13:03:10 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <altape@eden.rutgers.edu>,
	<luisca@cozybit.com>, <mb@bu3sch.de>, <jouni.malinen@atheros.com>,
	<colin@cozybit.com>, <javier@cozybit.com>
Subject: [PATCH] nl80211: relicense nl80211.h under the ISC
Date: Wed, 26 Nov 2008 13:03:08 -0800
Message-ID: <1227733388-13182-1-git-send-email-lrodriguez@atheros.com> (sfid-20081126_220316_217738_B738BCA8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have a few BSD/ISC licensed userspace applications which
include nl80211.h from the kernel. To avoid legal ambiguity
for usage of the header file in these projects we rather simply
relicense the header file under the ISC. We've received consent
from all contributors to it.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Michael Wu <flamingice@sourmilk.net>
Acked-by: Luis Carlos Cobo <luisca@cozybit.com>
Acked-by: Michael Buesch <mb@bu3sch.de>
Acked-by: Jouni Malinen <jouni.malinen@atheros.com>
Acked-by: Colin McCabe <colin@cozybit.com>
Acked-by: Javier Cardona <javier@cozybit.com>
Cc: johannes@sipsolutions.net
Cc: altape@eden.rutgers.edu
Cc: luisca@cozybit.com
Cc: mb@bu3sch.de
Cc: jouni.malinen@atheros.com
Cc: colin@cozybit.com
Cc: javier@cozybit.com
---
 include/linux/nl80211.h |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e08c8bc..3a7e14c 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -3,7 +3,26 @@
 /*
  * 802.11 netlink interface public header
  *
- * Copyright 2006, 2007 Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006, 2007, 2008 Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2008 Michael Wu <flamingice@sourmilk.net>
+ * Copyright 2008 Luis Carlos Cobo <luisca@cozybit.com>
+ * Copyright 2008 Michael Buesch <mb@bu3sch.de>
+ * Copyright 2008 Luis R. Rodriguez <lrodriguez@atheros.com>
+ * Copyright 2008 Jouni Malinen <jouni.malinen@atheros.com>
+ * Copyright 2008 Colin McCabe <colin@cozybit.com>
+ *
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
+ *
  */
 
 /**
-- 
1.5.6.rc2.15.g457bb.dirty

