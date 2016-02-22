Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:33407 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbcBVQhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 11:37:00 -0500
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>
Subject: [PATCHv2 02/10] rfkill: Remove extra blank line
Date: Mon, 22 Feb 2016 11:36:33 -0500
Message-Id: <1456159001-20307-3-git-send-email-jprvita@endlessm.com> (sfid-20160222_173918_655019_616ADF3C)
In-Reply-To: <1456159001-20307-1-git-send-email-jprvita@endlessm.com>
References: <1456159001-20307-1-git-send-email-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
---
 net/rfkill/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index ffbc375..56d79cb 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -455,7 +455,6 @@ bool rfkill_get_global_sw_state(const enum rfkill_type type)
 }
 #endif
 
-
 bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
 {
 	unsigned long flags;
-- 
2.5.0

