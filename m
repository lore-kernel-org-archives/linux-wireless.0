Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:47718 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133Ab3GPUHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 16:07:51 -0400
Received: by mail-pd0-f182.google.com with SMTP id r10so1041396pdi.27
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 13:07:50 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	pstew@chromium.org, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC v2] wireless-regdb: ID, Indonesia - enable 5 GHz and VHT80
Date: Tue, 16 Jul 2013 13:07:44 -0700
Message-Id: <1374005264-7650-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130716_220755_941063_2472FA89)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Pursuant to:

http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf,

provide a 5GHz rule for Indonesian regulatory domain. QCA has
also verified VHT80 can be enabled. Patch originally posted by
Paul Stewart <pstew@chromium.org>, I just modified to enable 80 MHz
bandwidth.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---

This v2 changes the bandwidth to 80 as was intended with the first
patch.

 db.txt |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index 0ebb934..8356d5d 100644
--- a/db.txt
+++ b/db.txt
@@ -380,7 +380,9 @@ country HU: DFS-ETSI
 	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country ID:
+	# ref: http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5735 - 5815 @ 80), (N/A, 20)
 
 country IE: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

