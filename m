Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:34300 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab2LVPpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 10:45:54 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 17/17] cw1200:  Integrate into staging tree
Date: Sat, 22 Dec 2012 10:45:20 -0500
Message-Id: <1356191120-5280-18-git-send-email-pizza@shaftnet.org> (sfid-20121222_164609_963173_32880E95)
In-Reply-To: <1356191120-5280-1-git-send-email-pizza@shaftnet.org>
References: <1356191120-5280-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/staging/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 329bdb4..ca8b790 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -142,4 +142,6 @@ source "drivers/staging/sb105x/Kconfig"
 
 source "drivers/staging/fwserial/Kconfig"
 
+source "drivers/staging/cw1200/Kconfig"
+
 endif # STAGING
-- 
1.7.11.7

