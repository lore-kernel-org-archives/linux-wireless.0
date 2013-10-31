Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:49980 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab3JaSdj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 14:33:39 -0400
Received: by mail-bk0-f52.google.com with SMTP id u14so812423bkz.11
        for <linux-wireless@vger.kernel.org>; Thu, 31 Oct 2013 11:33:38 -0700 (PDT)
Message-ID: <5272A27F.9060009@gmail.com> (sfid-20131031_194113_800374_00256B91)
Date: Thu, 31 Oct 2013 19:33:35 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wireless-regdb@lists.infradead.org
Subject: Re: French regulatory domain change request
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Jean-Pierre,

> The current description for France in regdb.txt is :
> country FR: DFS-ETSI
> 	(2402 - 2482 @ 40), (N/A, 20)
> 	(5170 - 5250 @ 80), (N/A, 20)
> 	(5250 - 5330 @ 80), (N/A, 20), DFS
> 	(5490 - 5710 @ 80), (N/A, 27), DFS
> 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
> 	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
> 
> Following this paper http://www.arcep.fr/uploads/tx_gsavis/08-0568.pdf 
> " Décision n° 2008-0568" issued by the ARCEP (French Electronic
> communications and Postoffice Regulation Authority) in the year 2008,
> 1) the frequencies 5150-5350 MHz are limited to INDOOR use.
>  (see page 5: "Dans la bande de fréquences*5150-5350* MHz, les WAS/RLAN sont
> limités à une *utilisation intérieure* ...")
> 2) the limits of the frequency band is ~20MHz greater for all frequency
> values (5150 vs. 5170, 5350 vs. 5330, 5470 vs. 5490, 5725 vs. 5710)

> So IMHO the description for France should read: 
> country FR: DFS-ETSI
> 	(2402 - 2482 @ 40), (N/A, 20)
> 	# ref: ARCEP 08-0568
> http://www.arcep.fr/uploads/tx_gsavis/08-0568.pdf
> 	(5150 - 5250 @ 80), (N/A, 20), NO-OUTDOOR
> 	(5250 - 5350 @ 80), (N/A, 20), NO-OUTDOOR, DFS
> 	(5470 - 5725 @ 80), (N/A, 27), DFS
> 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
> 	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
> By the way, this looks very like the description for Germany (DE)

You are right, but a patch is missing ;-)

BTW. It should be fixed for all, or nearly all, ETSI countries.
