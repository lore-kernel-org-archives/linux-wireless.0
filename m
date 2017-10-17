Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44332 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965952AbdJQTfB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 15:35:01 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wil6210: remove wil6210_uapi.h from MAINTAINERS
Date: Tue, 17 Oct 2017 21:34:58 +0200
Message-Id: <20171017193458.7473-1-johannes@sipsolutions.net> (sfid-20171017_213504_568083_00198A47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This file doesn't exist.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3944f1626911..7051e2ae9971 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14565,7 +14565,6 @@ L:	wil6210@qca.qualcomm.com
 S:	Supported
 W:	http://wireless.kernel.org/en/users/Drivers/wil6210
 F:	drivers/net/wireless/ath/wil6210/
-F:	include/uapi/linux/wil6210_uapi.h
 
 WIMAX STACK
 M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
-- 
2.14.2
