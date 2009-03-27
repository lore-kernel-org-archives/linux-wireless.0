Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33303 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbZC0EU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 00:20:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, pabs@debian.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/4] wireless-regdb: BN was missing two 5 GHz bands
Date: Fri, 27 Mar 2009 00:20:53 -0400
Message-Id: <1238127656-1226-2-git-send-email-lrodriguez@atheros.com> (sfid-20090327_052116_373625_DD26B6D5)
In-Reply-To: <1238127656-1226-1-git-send-email-lrodriguez@atheros.com>
References: <1238127656-1226-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two 5 GHz bands regulatory rules were missing for
Brunei Darussalam (BN). The document we referred to
is the:

"Spectrum Policy and Planning - Joint Policy
Issued by the TRA and the MOT   27 June 2006"

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 db.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/db.txt b/db.txt
index d3a05ea..77f1754 100644
--- a/db.txt
+++ b/db.txt
@@ -82,6 +82,8 @@ country BL:
 
 country BN:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 40), (N/A, 20)
+	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5735 - 5835 @ 40), (N/A, 30)
 
 country BO:
-- 
1.6.0.6

