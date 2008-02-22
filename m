Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7288 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbYBVFA4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 00:00:56 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 3/5] at76_usb: add more MODULE_AUTHOR entries
To: linux-wireless@vger.kernel.org, at76c503a-develop@lists.berlios.de
Date: Fri, 22 Feb 2008 00:00:55 -0500
Message-ID: <20080222050055.11158.50523.stgit@dv.roinet.com> (sfid-20080222_050102_127899_080EA461)
In-Reply-To: <20080222050044.11158.86655.stgit@dv.roinet.com>
References: <20080222050044.11158.86655.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 95c911e..da531a3 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -2537,5 +2537,7 @@ MODULE_AUTHOR("Alex <alex@foogod.com>");
 MODULE_AUTHOR("Nick Jones");
 MODULE_AUTHOR("Balint Seeber <n0_5p4m_p13453@hotmail.com>");
 MODULE_AUTHOR("Pavel Roskin <proski@gnu.org>");
+MODULE_AUTHOR("Guido Guenther <agx@sigxcpu.org>");
+MODULE_AUTHOR("Kalle Valo <kalle.valo@iki.fi>");
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
