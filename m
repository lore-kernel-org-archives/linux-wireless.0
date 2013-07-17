Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58491 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3GQCXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:23:07 -0400
Received: by mail-pd0-f174.google.com with SMTP id 10so1307808pdc.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:23:07 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 51/53] wireless-regdb: add 802.11ad 60 GHz channels 1..3 to world regdom
Date: Tue, 16 Jul 2013 19:18:40 -0700
Message-Id: <1374027522-18488-52-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_042310_919960_7807BB5B)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This is a port of what Vladimir Kondratiev sent to the
Linux kernel for the static world regulatory domain.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index c6def1c..54f89d3 100644
--- a/db.txt
+++ b/db.txt
@@ -10,6 +10,8 @@ country 00:
 	# NB: 5260 MHz - 5700 MHz requies DFS
 	# Channel 149 - 165
 	(5735 - 5835 @ 80), (3, 20), PASSIVE-SCAN, NO-IBSS
+	# IEEE 802.11ad (60GHz), channels 1..3
+	(57240 - 63720 @ 2160), (N/A, 0)
 
 
 country AD:
-- 
1.7.10.4

