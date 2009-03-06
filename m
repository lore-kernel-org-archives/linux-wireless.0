Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43779 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbZCFBqw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 20:46:52 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 17:46:51 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] wireless-regdb: enable 5 GHz world roaming
Date: Thu, 5 Mar 2009 17:46:08 -0800
Message-ID: <1236303969-22454-2-git-send-email-lrodriguez@atheros.com> (sfid-20090306_024655_778827_2131CFB5)
In-Reply-To: <1236303969-22454-1-git-send-email-lrodriguez@atheros.com>
References: <1236303969-22454-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 db.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/db.txt b/db.txt
index 89a9d52..3de2c9b 100644
--- a/db.txt
+++ b/db.txt
@@ -1,5 +1,6 @@
 country 00:
 	(2402 - 2472 @ 40), (3, 20)
+	(5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
 
 country AE:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.6.1.2.253.ga34a

