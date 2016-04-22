Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slowthinkers.net ([82.95.118.26]:43602 "EHLO
	density.slowthinkers.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbcDVMqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2016 08:46:35 -0400
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Update regulatory rules for NL as per ETSI EN 300 440-1
From: Anne Marcel Roorda <marcel@slowthinkers.net>
Date: Fri, 22 Apr 2016 14:36:13 +0200
Message-Id: <20160422123614.2B4EC2063D@density.slowthinkers.net> (sfid-20160422_144638_795966_1938BAF1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

  Below the patch to include SRD as per ETSI EN 300 440-1
for NL.

Thanks,

- marcel

Signed-off-by: Anne Marcel Roorda <marcel@slowthinkers.net>

diff --git a/db.txt b/db.txt
index e9ba21a..738e412 100644
--- a/db.txt
+++ b/db.txt
@@ -850,11 +850,18 @@ country NI: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+# Regulation on the use of frequency space without a license and 
+# without notification 2015
+#
+# http://wetten.overheid.nl/BWBR0036378/2015-03-05
+
 country NL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20), NO-OUTDOOR, AUTO-BW
 	(5250 - 5330 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# short range devices (ETSI EN 300 440-1)
+	(5725 - 5875 @ 80), (25 mW)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
