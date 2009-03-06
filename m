Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43780 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZCFBqy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 20:46:54 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 17:46:53 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] wireless-regdb: allow passive scan on Channels 12-14
Date: Thu, 5 Mar 2009 17:46:09 -0800
Message-ID: <1236303969-22454-3-git-send-email-lrodriguez@atheros.com> (sfid-20090306_024656_465209_DC84359F)
In-Reply-To: <1236303969-22454-1-git-send-email-lrodriguez@atheros.com>
References: <1236303969-22454-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 db.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/db.txt b/db.txt
index 3de2c9b..2ed2ee1 100644
--- a/db.txt
+++ b/db.txt
@@ -1,5 +1,12 @@
+# This is the world regulatory domain
 country 00:
+	# Channels 1-11 are allowed world wide
 	(2402 - 2472 @ 40), (3, 20)
+	# Channel 12 - 14. No HT40 channel fits here, note
+	# that channel 14 is currently only used by JP and
+	# exclusively only for 802.11b operation anyway.
+	(2457 - 2494 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS
+	# Channel 36 - 48
 	(5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
 
 country AE:
-- 
1.6.1.2.253.ga34a

