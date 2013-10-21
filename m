Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out03.msg.oleane.net ([62.161.7.1]:40078 "EHLO
	smtp-out03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3JUP2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 11:28:44 -0400
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: <linux-wireless@vger.kernel.org>,
	<wireless-regdb@lists.infradead.org>
Subject: French regulatory domain change request
Date: Mon, 21 Oct 2013 17:05:51 +0200
Message-ID: <000901cece6f$081ca5f0$1855f1d0$@acksys.fr> (sfid-20131021_172847_913584_0745CC74)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

The current description for France in regdb.txt is :
country FR: DFS-ETSI
	(2402 - 2482 @ 40), (N/A, 20)
	(5170 - 5250 @ 80), (N/A, 20)
	(5250 - 5330 @ 80), (N/A, 20), DFS
	(5490 - 5710 @ 80), (N/A, 27), DFS
	# 60 gHz band channels 1-4, ref: Etsi En 302 567
	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR

Following this paper http://www.arcep.fr/uploads/tx_gsavis/08-0568.pdf 
" Décision n° 2008-0568" issued by the ARCEP (French Electronic
communications and Postoffice Regulation Authority) in the year 2008,
1) the frequencies 5150-5350 MHz are limited to INDOOR use.
 (see page 5: "Dans la bande de fréquences*5150-5350* MHz, les WAS/RLAN sont
limités à une *utilisation intérieure* ...")
2) the limits of the frequency band is ~20MHz greater for all frequency
values (5150 vs. 5170, 5350 vs. 5330, 5470 vs. 5490, 5725 vs. 5710)

So IMHO the description for France should read: 
country FR: DFS-ETSI
	(2402 - 2482 @ 40), (N/A, 20)
	# ref: ARCEP 08-0568
http://www.arcep.fr/uploads/tx_gsavis/08-0568.pdf
	(5150 - 5250 @ 80), (N/A, 20), NO-OUTDOOR
	(5250 - 5350 @ 80), (N/A, 20), NO-OUTDOOR, DFS
	(5470 - 5725 @ 80), (N/A, 27), DFS
	# 60 gHz band channels 1-4, ref: Etsi En 302 567
	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR

By the way, this looks very like the description for Germany (DE) now!

Regards,
Jean-Pierre

