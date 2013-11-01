Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59040 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab3KAN7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:54 -0400
Received: by mail-wg0-f51.google.com with SMTP id l18so3988321wgh.18
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:53 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 51/65] wireless-regdb: add VHT80 rules for DZ
Date: Fri,  1 Nov 2013 14:57:41 +0100
Message-Id: <1383314275-20960-52-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150000_178265_BE9DFA17)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/db.txt b/db.txt
index aa92c37..82219e5 100644
--- a/db.txt
+++ b/db.txt
@@ -251,6 +251,9 @@ country DO: DFS-FCC
 
 country DZ: DFS-JP
 	(2402 - 2482 @ 40), (20)
+	(5170.000 - 5250.000 @ 80.000), (23.00)
+	(5250.000 - 5330.000 @ 80.000), (23.00), DFS
+	(5490.000 - 5670.000 @ 80.000), (23.00), DFS
 
 country EC: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

