Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63473 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab0LTRDG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 12:03:06 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 09:02:50 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <kathy.giori@atheros.com>, <amod.bodas@atheros.com>,
	<david.quan@atheros.com>, <michael.green@atheros.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 8/8] wireless-regdb: add FCC as the DFS region for US
Date: Mon, 20 Dec 2010 12:02:35 -0500
Message-ID: <1292864555-28661-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DFS master support in the US requires consideration for DFS
requirements as defined by the FCC rules.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 db.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/db.txt b/db.txt
index e63a43e..d1616ef 100644
--- a/db.txt
+++ b/db.txt
@@ -611,7 +611,7 @@ country TR:
 country UA:
 	(2402 - 2482 @ 40), (N/A, 20)
 
-country US:
+country US: DFS-FCC
 	(2402 - 2472 @ 40), (3, 27)
 	(5170 - 5250 @ 40), (3, 17)
 	(5250 - 5330 @ 40), (3, 20), DFS
-- 
1.7.3.2.90.gd4c43

