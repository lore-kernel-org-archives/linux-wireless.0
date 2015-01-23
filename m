Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64537 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbAWLws (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 06:52:48 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: Add regulatory rules for Tanzania (TZ)
Date: Fri, 23 Jan 2015 13:52:00 +0200
Message-ID: <1422013920-9779-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20150123_125250_478867_61E63D58)
In-Reply-To: <1422013920-9779-1-git-send-email-jouni@qca.qualcomm.com>
References: <1422013920-9779-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/db.txt b/db.txt
index 3ea53ec..85b4bb4 100644
--- a/db.txt
+++ b/db.txt
@@ -1104,6 +1104,10 @@ country TW: DFS-JP
 	(5650 - 5710 @ 40), (30), DFS
 	(5735 - 5835 @ 80), (30)
  
+country TZ:
+	(2402 - 2482 @ 40), (20)
+	(5735 - 5835 @ 80), (30)
+
 # Source:
 # #914 / 06 Sep 2007: http://www.ucrf.gov.ua/uk/doc/nkrz/1196068874
 # #1174 / 23 Oct 2008: http://www.nkrz.gov.ua/uk/activities/ruling/1225269361
-- 
1.9.1

