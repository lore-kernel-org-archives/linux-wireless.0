Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17360 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbcEUJZO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 May 2016 05:25:14 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	wil6210@qca.qualcomm.com
Subject: [PATCH] wireless-regdb: Republic of Korea: Add 60GHz regulatory rules
Date: Sat, 21 May 2016 12:25:08 +0300
Message-Id: <1463822708-20053-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160521_112525_821787_0920612F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add 60GHz regulatory rules for Korea (KR).
Source is
http://www.law.go.kr/%ED%96%89%EC%A0%95%EA%B7%9C%EC%B9%99/%EB%AC%B4%EC%84%A0%EC%84%A4%EB%B9%84%EA%B7%9C%EC%B9%99

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 db.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/db.txt b/db.txt
index da16f7c..143f915 100644
--- a/db.txt
+++ b/db.txt
@@ -664,6 +664,10 @@ country KR: DFS-JP
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (30), DFS
 	(5735 - 5835 @ 80), (30)
+	# 60 GHz band channels 1-4,
+	# ref: http://www.law.go.kr/%ED%96%89%EC%A0%95%EA%B7%9C%EC%B9%99/%EB%AC%B4%EC%84%A0%EC%84%A4%EB%B9%84%EA%B7%9C%EC%B9%99
+	(57000 - 66000 @ 2160), (57)
+
 
 country KW: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.5.2

