Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1673 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996Ab2K1Uo1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 15:44:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/11] brcm80211: update the MAINTAINERS file
Date: Wed, 28 Nov 2012 21:44:04 +0100
Message-ID: <1354135454-7035-2-git-send-email-arend@broadcom.com> (sfid-20121128_214449_097872_CE978470)
In-Reply-To: <1354135454-7035-1-git-send-email-arend@broadcom.com>
References: <1354135454-7035-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Organizational changes need to be reflected in the MAINTAINERS file.
The contact info on wireless.kernel.org has also been updated.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f3d9d62..ed91c27 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1674,10 +1674,9 @@ F:	drivers/net/ethernet/broadcom/tg3.*
 
 BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
 M:	Brett Rudley <brudley@broadcom.com>
-M:	Roland Vossen <rvossen@broadcom.com>
 M:	Arend van Spriel <arend@broadcom.com>
 M:	Franky (Zhenhui) Lin <frankyl@broadcom.com>
-M:	Kan Yan	<kanyan@broadcom.com>
+M:	Hante Meuleman <meuleman@broadcom.com>
 L:	linux-wireless@vger.kernel.org
 L:	brcm80211-dev-list@broadcom.com
 S:	Supported
-- 
1.7.10.4


