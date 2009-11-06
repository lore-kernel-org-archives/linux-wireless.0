Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34941 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759574AbZKFTOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 14:14:36 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Michael Green <Michael.Green@atheros.com>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>
Subject: [PATCH] wireless-regdb: add Aruba (AW)
Date: Fri,  6 Nov 2009 14:14:41 -0500
Message-Id: <1257534881-27345-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were unable to find published rules for Aruba
for regulatory purposes but given that it falls under
the same european region we have mapped Aruba to the same
region as other european countries and give it the same
rules. A device was tested for ETSI certification with
these rules and passed so I think this is a best due dillegence
as we can do to test regulatory rules for Aruba.

Reported-by: Jeffrey Baker <jwbaker@gmail.com>
Cc: Michael Green <Michael.Green@atheros.com>
Cc: Vivek Natarajan <Vivek.Natarajan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 db.txt |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/db.txt b/db.txt
index c71b35b..a3cd6be 100644
--- a/db.txt
+++ b/db.txt
@@ -46,6 +46,12 @@ country AU:
 	(5250 - 5330 @ 40), (3, 23), DFS
 	(5735 - 5835 @ 40), (3, 30)
 
+country AW:
+	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 40), (N/A, 20)
+	(5250 - 5330 @ 40), (N/A, 20), DFS
+	(5490 - 5710 @ 40), (N/A, 27), DFS
+
 country AZ:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 18)
-- 
1.6.5.2.143.g8cc62

