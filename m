Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1121 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab0LHVKK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 16:10:10 -0500
From: "Henry Ptasinski" <henryp@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH v2] MAINTAINERS: update the entry for the BRCM80211
 driver
Date: Wed, 8 Dec 2010 13:09:49 -0800
Message-ID: <1291842589-9543-1-git-send-email-henryp@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This time with Signed-off-by ...

Removed Nohee, added Roland, Arend and Dowan.  Changes were previously made
to drivers/staging/brcm80211{README,TODO}, but MAINTAINERS was missed.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
---
 MAINTAINERS |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1a1c27b..fdb4137 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1394,7 +1394,9 @@ F:	drivers/net/tg3.*
 BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
 M:	Brett Rudley <brudley@broadcom.com>
 M:	Henry Ptasinski <henryp@broadcom.com>
-M:	Nohee Ko <noheek@broadcom.com>
+M:	Dowan Kim <dowan@broadcom.com>
+M:	Roland Vossen <rvossen@broadcom.com>
+M:	Arend van Spriel <arend@broadcom.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
 F:	drivers/staging/brcm80211/
-- 
1.7.1


