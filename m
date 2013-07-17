Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43381 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3GQCWn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:22:43 -0400
Received: by mail-pa0-f52.google.com with SMTP id kq14so317183pab.25
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:22:42 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 46/53] wireless-regdb: MA, Morocco - enable 5 GHz and VHT80
Date: Tue, 16 Jul 2013 19:18:35 -0700
Message-Id: <1374027522-18488-47-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_042245_485473_FB70916C)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This adds 5 GHz support for Morocco with VHT80 support.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index c626a48..c76131b 100644
--- a/db.txt
+++ b/db.txt
@@ -523,6 +523,8 @@ country MC: DFS-ETSI
 
 country MA:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 80), (N/A, 23)
+	(5735 - 5835 @ 80), (N/A, 23)
 
 country MO:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

