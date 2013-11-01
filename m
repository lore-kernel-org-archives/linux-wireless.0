Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37038 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3KAN7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:49 -0400
Received: by mail-wi0-f180.google.com with SMTP id ey11so1109355wid.7
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:49 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 49/65] wireless-regdb: add VHT80 rules for CN
Date: Fri,  1 Nov 2013 14:57:39 +0100
Message-Id: <1383314275-20960-50-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145955_397956_E6B70CBB)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index 551fe14..4ce2017 100644
--- a/db.txt
+++ b/db.txt
@@ -170,6 +170,8 @@ country CL: DFS-JP
 
 country CN: DFS-FCC
 	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (23)
+	(5250 - 5330 @ 80), (23), DFS
 	(5735 - 5835 @ 80), (30)
 	# 60 gHz band channels 1,4: 28dBm, channels 2,3: 44dBm
 	# ref: http://www.miit.gov.cn/n11293472/n11505629/n11506593/n11960250/n11960606/n11960700/n12330791.files/n12330790.pdf
-- 
1.8.4.rc3

