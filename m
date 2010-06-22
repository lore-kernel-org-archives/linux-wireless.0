Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:11429 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab0FVUkv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 16:40:51 -0400
Subject: [PATCH] compat-wireless: "crap" code is "not yet posted",
 not "not yet merged"
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 22 Jun 2010 16:40:48 -0400
Message-ID: <20100622204048.5228.76910.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---
 scripts/admin-update.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 7592546..4eb7c3e 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -85,7 +85,7 @@ nag_pending() {
 
 nag_crap() {
 	printf "${RED}%10s${NORMAL} - Crap changes not yet posted\n" $2
-	printf "${RED}%10s${NORMAL} - Crap additions not yet merged\n" $3
+	printf "${RED}%10s${NORMAL} - Crap additions not yet posted\n" $3
 	printf "${RED}%10s${NORMAL} - Crap deletions not yet posted\n" $4
 	printf "${RED}%10s${NORMAL} - %% of crap code\n" $(perl -e 'printf("%.4f", 100 * '$2' / '$1');')
 }
