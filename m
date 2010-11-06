Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33441 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab0KFOtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 10:49:41 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so2216256eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 07:49:40 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/18] rt2x00: checkpatch.pl error fixes for rt2800lib.c
Date: Sat, 6 Nov 2010 15:45:06 +0100
Cc: linux-wireless@vger.kernel.org
References: <201011061544.00876.IvDoorn@gmail.com> <201011061544.33907.IvDoorn@gmail.com> <201011061544.52879.IvDoorn@gmail.com>
In-Reply-To: <201011061544.52879.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011061545.07105.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mark Einon <mark.einon@gmail.com>

rt2800lib.c:831: ERROR: inline keyword should sit between storage class and type

Signed-off-by: Mark Einon <mark.einon@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a53536d..b5d2eba 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -828,7 +828,7 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 }
 EXPORT_SYMBOL_GPL(rt2800_write_beacon);
 
-static void inline rt2800_clear_beacon(struct rt2x00_dev *rt2x00dev,
+static inline void rt2800_clear_beacon(struct rt2x00_dev *rt2x00dev,
 				       unsigned int beacon_base)
 {
 	int i;
-- 
1.7.2.3

