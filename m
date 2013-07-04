Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48626 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab3GDBH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 21:07:59 -0400
Received: by mail-pd0-f170.google.com with SMTP id x11so593561pdj.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 18:07:59 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 42/53] wireless-regdb: ID, Indonesia - enable 5 GHz and VHT80
Date: Wed,  3 Jul 2013 18:04:38 -0700
Message-Id: <1372899889-19183-43-git-send-email-mcgrof@do-not-panic.com> (sfid-20130704_032042_813021_4B6569A2)
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
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
 db.txt |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index 0ebb934..a101b1e 100644
--- a/db.txt
+++ b/db.txt
@@ -380,7 +380,9 @@ country HU: DFS-ETSI
 	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country ID:
+	# ref: http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5735 - 5815 @ 20), (N/A, 20)
 
 country IE: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

