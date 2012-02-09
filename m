Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3942 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757887Ab2BIUJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/15] brcm80211: update the maintainers listed for
 brcm80211 drivers
Date: Thu, 9 Feb 2012 21:08:55 +0100
Message-ID: <1328818149-4826-2-git-send-email-arend@broadcom.com> (sfid-20120209_211002_354263_4DF54656)
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henry Ptasinski is not working on the brcm80211 driver so taking
his name/email out of the MAINTAINERS file.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ea653fd..50b85eba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1575,7 +1575,6 @@ F:	drivers/net/ethernet/broadcom/tg3.*
 
 BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
 M:	Brett Rudley <brudley@broadcom.com>
-M:	Henry Ptasinski <henryp@broadcom.com>
 M:	Roland Vossen <rvossen@broadcom.com>
 M:	Arend van Spriel <arend@broadcom.com>
 M:	Franky (Zhenhui) Lin <frankyl@broadcom.com>
-- 
1.7.5.4


