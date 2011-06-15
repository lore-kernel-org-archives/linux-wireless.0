Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:19447 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab1FOWBM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 18:01:12 -0400
Subject: [PATCH 2/2] ath9k: typo fix in a comment
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 15 Jun 2011 18:01:11 -0400
Message-ID: <20110615220111.1755.79276.stgit@mj.roinet.com> (sfid-20110616_000116_179615_0F08C7C0)
In-Reply-To: <20110615220105.1755.45521.stgit@mj.roinet.com>
References: <20110615220105.1755.45521.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b9c177f..56a0ac4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -577,7 +577,7 @@ struct ath9k_vif_iter_data {
 	int naps;      /* number of AP vifs */
 	int nmeshes;   /* number of mesh vifs */
 	int nstations; /* number of station vifs */
-	int nwds;      /* number of nwd vifs */
+	int nwds;      /* number of WDS vifs */
 	int nadhocs;   /* number of adhoc vifs */
 	int nothers;   /* number of vifs not specified above. */
 };
