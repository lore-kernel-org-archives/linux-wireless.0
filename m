Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:41485 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab1KSLE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 06:04:28 -0500
Subject: [PATCH 5/5] rndis_wlan: remove unused macro
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 19 Nov 2011 13:04:26 +0200
Message-ID: <20111119110426.11950.78317.stgit@localhost6.localdomain6> (sfid-20111119_120433_611298_02C275FB)
In-Reply-To: <20111119110405.11950.91713.stgit@localhost6.localdomain6>
References: <20111119110405.11950.91713.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NET_TYPE_11FB actually has never been used.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 56514d9..3802c31 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -402,8 +402,6 @@ struct ndis_80211_pmkid {
 /*
  *  private data
  */
-#define NET_TYPE_11FB	0
-
 #define CAP_MODE_80211A		1
 #define CAP_MODE_80211B		2
 #define CAP_MODE_80211G		4

