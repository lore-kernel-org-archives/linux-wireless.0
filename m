Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37439 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab1LUAFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 19:05:07 -0500
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<zefir.kurtisi@neratec.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 2/2] wireless-regdb: add FCC as the DFS region for US
Date: Tue, 20 Dec 2011 16:04:12 -0800
Message-ID: <1324425852-4492-3-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111221_010509_935979_32A7EEC1)
In-Reply-To: <1324425852-4492-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1324425852-4492-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

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

