Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42521 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab0DHUK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 16:10:26 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] iw: fix typo on LDPC capability
Date: Thu,  8 Apr 2010 16:10:25 -0400
Message-Id: <1270757425-26882-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/util.c b/util.c
index 9fc0844..42c992d 100644
--- a/util.c
+++ b/util.c
@@ -436,7 +436,7 @@ void print_ht_capability(__u16 cap)
 
 	printf("\t\tCapabilities: 0x%02x\n", cap);
 
-	PRINT_HT_CAP((cap & BIT(0)), "RX LDCP");
+	PRINT_HT_CAP((cap & BIT(0)), "RX LDPC");
 	PRINT_HT_CAP((cap & BIT(1)), "HT20/HT40");
 	PRINT_HT_CAP(!(cap & BIT(1)), "HT20");
 
-- 
1.6.3.3

