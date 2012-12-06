Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37214 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946515Ab2LFSRd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 13:17:33 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 05/13] qca-swiss-army-knife: add missing families to verify_checksums.sh
Date: Thu,  6 Dec 2012 19:17:19 +0100
Message-Id: <1354817847-23440-6-git-send-email-juhosg@openwrt.org> (sfid-20121206_191737_792928_38DE8375)
In-Reply-To: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the missing ar9340, ar9462-1p0, ar9565-1p0
families to the 'verify_checksums.sh' script.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/verify_checksums.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/initvals/verify_checksums.sh b/tools/initvals/verify_checksums.sh
index 6878ca5..46fff90 100755
--- a/tools/initvals/verify_checksums.sh
+++ b/tools/initvals/verify_checksums.sh
@@ -31,7 +31,7 @@ verify_family_checksum()
 }
 
 FAMILIES="$@"
-[ -z "$FAMILIES" ] && FAMILIES="ar5008 ar9001 ar9002 ar9003-2p2 ar9330-1p1 ar9330-1p2 ar9485 ar9580-1p0"
+[ -z "$FAMILIES" ] && FAMILIES="ar5008 ar9001 ar9002 ar9003-2p2 ar9330-1p1 ar9330-1p2 ar9340 ar9462-1p0 ar9485 ar9565-1p0 ar9580-1p0"
 
 mkdir -p "$CSUM_DIR"
 for family in $FAMILIES; do
-- 
1.7.10

