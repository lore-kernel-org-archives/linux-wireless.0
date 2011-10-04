Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36705 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933860Ab1JDXsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 19:48:00 -0400
Received: by ggnv2 with SMTP id v2so478718ggn.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 16:48:00 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 2/8] wireless-regdb: add FCC as the DFS region for US
Date: Tue,  4 Oct 2011 16:47:41 -0700
Message-Id: <1317772067-6998-3-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111005_014804_974591_2A73BC71)
In-Reply-To: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DFS master support in the US requires consideration for DFS
requirements as defined by the FCC rules.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 db.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/db.txt b/db.txt
index f0b46d8..4b7e879 100644
--- a/db.txt
+++ b/db.txt
@@ -651,7 +651,7 @@ country TR:
 country UA:
 	(2402 - 2482 @ 40), (N/A, 20)
 
-country US:
+country US: DFS-FCC
 	(2402 - 2472 @ 40), (3, 27)
 	(5170 - 5250 @ 40), (3, 17)
 	(5250 - 5330 @ 40), (3, 20), DFS
-- 
1.7.4.15.g7811d

