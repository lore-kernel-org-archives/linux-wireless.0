Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from SMTP.ANDREW.CMU.EDU ([128.2.10.159]:43978 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZCTRZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 13:25:24 -0400
Received: from [128.2.158.14] (QUEENOFLIGHT.RES.CMU.EDU [128.2.158.14])
	(user=jwatzman mech=GSSAPI (0 bits))
	by smtp.andrew.cmu.edu (8.14.3/8.13.8) with ESMTP id n2KHChKe028691
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2009 13:12:43 -0400
Message-ID: <49C3CE8B.6070702@andrew.cmu.edu> (sfid-20090320_182529_496964_B7BFE94A)
Date: Fri, 20 Mar 2009 13:12:43 -0400
From: Josh Watzman <jwatzman@andrew.cmu.edu>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] compat.diff update for master-2009-03-19
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A trivial fix to allow compat-wireless to apply against current wireless-testing.

Signed-off-by: Josh Watzman <jwatzman@andrew.cmu.edu>
---
 compat/compat.diff |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index e723fc8..44a9029 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -18,8 +18,8 @@
  obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
  obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
  
--cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
-+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o compat.o
+-cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o
++cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o compat.o
  cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
  
  ccflags-y += -D__CHECK_ENDIAN__
-- 
1.6.2.1

