Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57191 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2D1G0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 02:26:07 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	<wireless-regdb@lists.infradead.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] wireless-regdb: add Rwanda (RW)
Date: Sat, 28 Apr 2012 11:57:00 +0530
Message-ID: <1335594420-1878-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120428_082612_629728_3F573140)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As per the Rwanda regulatory guidelines, the following bands are
designated for ISM applications.

2400-2500 MHz (centre frequency 2 450 MHz)
5725-5875 MHz (centre frequency 5 800 MHz)

Ref: www.rura.gov.rw/publication/ISMbandguidelines.pdf

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 db.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/db.txt b/db.txt
index 23b85a3..4c54543 100644
--- a/db.txt
+++ b/db.txt
@@ -580,6 +580,10 @@ country RU:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5735 - 5835 @ 20), (N/A, 30)
 
+country RW:
+	(2402 - 2482 @ 40), (N/A, 20)
+	(5735 - 5835 @ 40), (N/A, 30)
+
 country SA:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 20), (3, 23)
-- 
1.7.10

