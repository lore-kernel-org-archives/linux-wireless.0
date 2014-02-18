Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:50617 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaBRJIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 04:08:17 -0500
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <clg@fr.ibm.com>;
	Tue, 18 Feb 2014 09:08:15 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 08CC52190063
	for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 09:08:11 +0000 (GMT)
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1I9819X1573172
	for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 09:08:01 GMT
Received: from d06av02.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s1I98CFR013744
	for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 02:08:13 -0700
From: =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@fr.ibm.com>
To: Jouni Malinen <j@w1.fi>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@fr.ibm.com>
Subject: [PATCH] hostap: add Netgear MA401 card
Date: Tue, 18 Feb 2014 10:07:52 +0100
Message-Id: <1392714472-13998-1-git-send-email-clg@fr.ibm.com> (sfid-20140218_100823_776644_2B865155)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a relatively old Prism2 card which is correctly supported
by the hostap driver.

Signed-off-by: Cédric Le Goater <clg@fr.ibm.com>
---
 drivers/net/wireless/hostap/hostap_cs.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 9f825f2620da..b6ec51923b20 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -677,6 +677,8 @@ static const struct pcmcia_device_id hostap_cs_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12(
 		"ZoomAir 11Mbps High", "Rate wireless Networking",
 		0x273fe3db, 0x32a1eaee),
+	PCMCIA_DEVICE_PROD_ID12("NETGEAR MA401 Wireless PC", "Card",
+		0xa37434e9, 0x9762e8f1),
 	PCMCIA_DEVICE_PROD_ID123(
 		"Pretec", "CompactWLAN Card 802.11b", "2.5",
 		0x1cadd3e5, 0xe697636c, 0x7a5bfcf1),
-- 
1.7.10.4

