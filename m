Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40962 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbZCWXRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 19:17:14 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Michael.Green@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/2] wireless-regdb: BN was missing two 5 GHz bands
Date: Mon, 23 Mar 2009 19:17:11 -0400
Message-Id: <1237850232-24513-1-git-send-email-lrodriguez@atheros.com> (sfid-20090324_001718_375058_1E822BC2)
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

