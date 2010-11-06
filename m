Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44208 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab0KFOtx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 10:49:53 -0400
Received: by mail-ew0-f46.google.com with SMTP id 7so2253925ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 07:49:52 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/18] rt2x00: checkpatch.pl error fixes for rt2x00link.c
Date: Sat, 6 Nov 2010 15:47:09 +0100
Cc: linux-wireless@vger.kernel.org
References: <201011061544.00876.IvDoorn@gmail.com> <201011061546.37042.IvDoorn@gmail.com> <201011061546.53938.IvDoorn@gmail.com>
In-Reply-To: <201011061546.53938.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011061547.09763.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mark Einon <mark.einon@gmail.com>

rt2x00link.c:70: ERROR: space prohibited before that close parenthesis ')'

Signed-off-by: Mark Einon <mark.einon@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00link.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index b971d87..bfda60e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -67,7 +67,7 @@
 	    (__avg).avg_weight  ? \
 		((((__avg).avg_weight * ((AVG_SAMPLES) - 1)) + \
 		  ((__val) * (AVG_FACTOR))) / \
-		 (AVG_SAMPLES) ) : \
+		 (AVG_SAMPLES)) : \
 		((__val) * (AVG_FACTOR)); \
 	__new.avg = __new.avg_weight / (AVG_FACTOR); \
 	__new; \
-- 
1.7.2.3

