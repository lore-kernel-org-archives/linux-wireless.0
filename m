Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:1090 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636Ab2IPU35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2012 16:29:57 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 0/5] Assorted clean ups and a fix.
Date: Sun, 16 Sep 2012 22:29:48 +0200
Message-Id: <1347827393-26948-1-git-send-email-gwingerde@gmail.com> (sfid-20120916_223100_785822_B0C31B29)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another round of small clean ups to the rt2800 driver of rt2x00.
Also included is a fix for RT3572, in which rt2x00 deviated from the Ralink
driver when determining the default vgc for the 5GHz band.

--
Gertjan

---

Gertjan van Wingerde (5):
  rt2x00: Code clean up in rt2800lib.
  rt2x00: rt2800 - Fix default vgc values for RT3572
  rt2x00: rt2800lib - code cleanup.
  rt2x00: Code style cleanup in rt2800lib.c
  rt2x00: Clean up RFCSR1 programming in rt2800_config_channel_rf3xxx.

 drivers/net/wireless/rt2x00/rt2800lib.c | 72 +++++++++++++--------------------
 1 file changed, 29 insertions(+), 43 deletions(-)

-- 
1.7.11.1

