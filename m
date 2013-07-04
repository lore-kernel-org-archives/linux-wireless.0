Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36397 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab3GDBIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 21:08:18 -0400
Received: by mail-pd0-f170.google.com with SMTP id x11so590852pdj.15
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 18:08:17 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 46/53] wireless-regdb: MA, Morocco - enable 5 GHz and VHT80
Date: Wed,  3 Jul 2013 18:04:42 -0700
Message-Id: <1372899889-19183-47-git-send-email-mcgrof@do-not-panic.com> (sfid-20130704_032040_906173_8007C267)
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This adds 5 GHz support for Morocco with VHT80 support.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index fa8502c..aa41626 100644
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

