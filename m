Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4921 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab3ABOMz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:12:55 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: [PATCH for 3.8 1/2] brcmsmac: add copyright information for
 Canonical
Date: Wed, 2 Jan 2013 15:12:38 +0100
Message-ID: <1357135959-16696-1-git-send-email-arend@broadcom.com> (sfid-20130102_151300_147884_C6261642)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patches from Canonical involved the introduction of new source
files debug.[ch]. That coincided with other patches from Broadcom
introducing the same files.

Cc: Seth Forshee <seth.forshee@canonical.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

Not really a bug fix, but giving credit where it is due.

Gr. AvS
---
 drivers/net/wireless/brcm80211/brcmsmac/debug.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.h b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
index 796836b..822781c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/debug.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2012 Broadcom Corporation
+ * Copyright (c) 2012 Canonical Ltd.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
-- 
1.7.10.4


