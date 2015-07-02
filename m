Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:35767 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbbGBROs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 13:14:48 -0400
Received: by iecuq6 with SMTP id uq6so61034796iec.2
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 10:14:48 -0700 (PDT)
From: Wei Zhong <wzhong@google.com>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	Wei Zhong <wzhong@google.com>
Subject: [PATCH] wireless-regdb: update CA rules for 5600 - 5650 mHz
Date: Thu,  2 Jul 2015 10:14:36 -0700
Message-Id: <1435857276-19209-1-git-send-email-wzhong@google.com> (sfid-20150702_191455_875381_B228DC0C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Related regulation:
http://www.ic.gc.ca/eic/site/smt-gst.nsf/eng/sf10971.html#s6.2.3

Frequency Bands 5470-5600 MHz and 5650-5725 MHz
Until further notice, devices subject to this section [i.e. Wifi device
supporting 5 GHz bands] shall not be capable of transmitting in the band
5600-5650 MHz. This restriction is for the protection of Environment
Canada’s weather radars operating in this band.

Signed-off-by: Wei Zhong <wzhong@google.com>
---
 db.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 809cd3c..da0cfad 100644
--- a/db.txt
+++ b/db.txt
@@ -216,7 +216,8 @@ country CA: DFS-FCC
 	(2402 - 2472 @ 40), (30)
 	(5170 - 5250 @ 80), (17), AUTO-BW
 	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
-	(5490 - 5730 @ 160), (24), DFS
+	(5490 - 5600 @ 80), (24), DFS
+	(5650 - 5730 @ 40), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
 # Source:
-- 
2.4.3.573.g4eafbef

