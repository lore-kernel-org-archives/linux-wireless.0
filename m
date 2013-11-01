Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35268 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab3KAN74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:56 -0400
Received: by mail-wi0-f169.google.com with SMTP id cb5so1203219wib.0
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:56 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 52/65] wireless-regdb: add VHT80 rules for ZW
Date: Fri,  1 Nov 2013 14:57:42 +0100
Message-Id: <1383314275-20960-53-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150004_392340_55E830DC)
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
index 82219e5..91e8871 100644
--- a/db.txt
+++ b/db.txt
@@ -833,4 +833,7 @@ country ZA: DFS-ETSI
 
 country ZW: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
 
-- 
1.8.4.rc3

