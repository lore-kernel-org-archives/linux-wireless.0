Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4828 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161296Ab1FALq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:27 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 29/83] staging: brcm80211: removed include/proto dir
Date: Wed, 1 Jun 2011 13:45:14 +0200
Message-ID: <1306928768-7501-29-git-send-email-rvossen@broadcom.com> (sfid-20110601_134641_514781_A724B4EF)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/include/proto/bcmeth.h   |   20 ------------------
 drivers/staging/brcm80211/include/proto/bcmevent.h |   22 --------------------
 2 files changed, 0 insertions(+), 42 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/include/proto/bcmeth.h
 delete mode 100644 drivers/staging/brcm80211/include/proto/bcmevent.h

diff --git a/drivers/staging/brcm80211/include/proto/bcmeth.h b/drivers/staging/brcm80211/include/proto/bcmeth.h
deleted file mode 100644
index 0053984..0000000
--- a/drivers/staging/brcm80211/include/proto/bcmeth.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef _BCMETH_H_
-#define _BCMETH_H_
-
-#endif				/* _BCMETH_H_ */
diff --git a/drivers/staging/brcm80211/include/proto/bcmevent.h b/drivers/staging/brcm80211/include/proto/bcmevent.h
deleted file mode 100644
index 1f4ab64..0000000
--- a/drivers/staging/brcm80211/include/proto/bcmevent.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef _BCMEVENT_H_
-#define _BCMEVENT_H_
-
-#include <linux/if_ether.h>
-
-#endif				/* _BCMEVENT_H_ */
-- 
1.7.4.1


