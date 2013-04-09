Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:34178 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3DIFxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 01:53:19 -0400
Received: by mail-da0-f45.google.com with SMTP id v40so2928599dad.18
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 22:53:18 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: qca_vkondrat@qca.qualcomm.com, yunsenw@qca.qualcomm.com,
	kandala@qca.qualcomm.com, wireless-regdb@lists.infradead.org,
	green@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 3/3] wireless-regdb: add VHT channels 1..3 to world regdom
Date: Mon,  8 Apr 2013 22:52:58 -0700
Message-Id: <1365486778-2336-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20130409_075322_170119_582B1385)
In-Reply-To: <1365486778-2336-1-git-send-email-mcgrof@do-not-panic.com>
References: <1365486778-2336-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This is a port of what Vladimir Kondratiev sent to the
Linux kernel for the static world regulatory domain.

Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Yunsen Wang <yunsenw@qca.qualcomm.com>
Cc: wireless-regdb@lists.infradead.org
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index ae0f83d..5657c11 100644
--- a/db.txt
+++ b/db.txt
@@ -10,6 +10,8 @@ country 00:
 	# NB: 5260 MHz - 5700 MHz requies DFS
 	# Channel 149 - 165
 	(5735 - 5835 @ 80), (3, 20), PASSIVE-SCAN, NO-IBSS
+	# IEEE 802.11ad (60gHz), channels 1..3
+	(57240 - 63720 @ 2160), (N/A, 0)
 
 
 country AD:
-- 
1.7.10.4

