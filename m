Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53948 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3GBRZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 13:25:39 -0400
Received: by mail-vc0-f202.google.com with SMTP id ha12so484582vcb.5
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jul 2013 10:25:38 -0700 (PDT)
From: Paul Stewart <pstew@chromium.org>
Date: Tue, 2 Jul 2013 10:20:33 -0700
Subject: wireless-regdb: 5GHz rule for Indonesia regdomain
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20130702172537.DC8F62006D3@clearcreek.mtv.corp.google.com> (sfid-20130702_192542_504144_B36459DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pursuant to
http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf, provide a 5GHz rule for Indonesian regulatory domain.
---
 db.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index c5861b8..2c0dffd 100644
--- a/db.txt
+++ b/db.txt
@@ -377,6 +377,8 @@ country HU: DFS-ETSI
 
 country ID:
 	(2402 - 2482 @ 40), (N/A, 20)
+	# ref: http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf
+	(5735 - 5815 @ 20), (N/A, 20)
 
 country IE: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.8.3

