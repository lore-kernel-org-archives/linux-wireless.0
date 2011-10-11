Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56782 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab1JKR7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 13:59:42 -0400
Received: by qyk7 with SMTP id 7so6852376qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 10:59:41 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 2/2] wireless-regdb: add FCC as the DFS region for US
Date: Tue, 11 Oct 2011 10:58:59 -0700
Message-Id: <1318355944-24708-3-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111011_195945_471947_BDDC095E)
In-Reply-To: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com>
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

