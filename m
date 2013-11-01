Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:42626 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3KAN7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:45 -0400
Received: by mail-we0-f179.google.com with SMTP id w61so3916071wes.24
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:44 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 47/65] wireless-regdb: add VHT80 rules for BD
Date: Fri,  1 Nov 2013 14:57:37 +0100
Message-Id: <1383314275-20960-48-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150810_290651_2245D50B)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/db.txt b/db.txt
index 68e896c..f63565c 100644
--- a/db.txt
+++ b/db.txt
@@ -91,6 +91,7 @@ country BB: DFS-FCC
 
 country BD: DFS-JP
 	(2402 - 2482 @ 40), (20)
+	(5735 - 5835 @ 80), (30)
 
 country BE: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

