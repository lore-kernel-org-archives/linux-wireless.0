Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51905 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab2GCQti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:49:38 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 03/10] qca-swiss-army-knife: add ar9462-2p0 to verify_checksums.sh
Date: Tue,  3 Jul 2012 18:42:48 +0200
Message-Id: <1341333775-14091-4-git-send-email-juhosg@openwrt.org> (sfid-20120703_184942_954585_60E8A50A)
In-Reply-To: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
References: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/verify_checksums.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/initvals/verify_checksums.sh b/tools/initvals/verify_checksums.sh
index 6878ca5..fd03478 100755
--- a/tools/initvals/verify_checksums.sh
+++ b/tools/initvals/verify_checksums.sh
@@ -31,7 +31,7 @@ verify_family_checksum()
 }
 
 FAMILIES="$@"
-[ -z "$FAMILIES" ] && FAMILIES="ar5008 ar9001 ar9002 ar9003-2p2 ar9330-1p1 ar9330-1p2 ar9485 ar9580-1p0"
+[ -z "$FAMILIES" ] && FAMILIES="ar5008 ar9001 ar9002 ar9003-2p2 ar9330-1p1 ar9330-1p2 ar9462-2p0 ar9485 ar9580-1p0"
 
 mkdir -p "$CSUM_DIR"
 for family in $FAMILIES; do
-- 
1.7.2.1

