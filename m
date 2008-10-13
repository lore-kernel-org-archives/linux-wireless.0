Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32771 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbYJNEIS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 00:08:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2008 21:08:18 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>,
	<mickflemm@gmail.com>, <jirislaby@gmail.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 0/3] ath5k/ath9k: correct signal quality
Date: Mon, 13 Oct 2008 14:08:07 -0700
Message-ID: <1223932090-9274-1-git-send-email-lrodriguez@atheros.com> (sfid-20081014_060823_555120_0826C9B1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that we officially are supporting ath5k I can do this
at work hours.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8dae455..3503cac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -731,7 +731,7 @@ M:	jirislaby@gmail.com
 P:	Nick Kossifidis
 M:	mickflemm@gmail.com
 P:	Luis R. Rodriguez
-M:	mcgrof@gmail.com
+M:	lrodriguez@atheros.com
 L:	linux-wireless@vger.kernel.org
 L:	ath5k-devel@lists.ath5k.org
 S:	Maintained
-- 
1.5.6.rc2.15.g457bb.dirty

