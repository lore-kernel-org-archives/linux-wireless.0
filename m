Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36833 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3BNACN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 19:02:13 -0500
Received: by mail-wi0-f180.google.com with SMTP id hi8so2100586wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2013 16:02:12 -0800 (PST)
Message-ID: <511C2981.4000806@gmail.com> (sfid-20130214_010221_602864_1446A666)
Date: Thu, 14 Feb 2013 01:02:09 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	wireless-regdb@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [wireless-regdb] wireless-regdb: Update regulatory rules for
 Serbia (RS) on 2.4 and 5GHz
References: <CAL1G+-HfPJnwvisiE5Vr0ihenwKzL3_QL40DLPP_PsPyv+nveQ@mail.gmail.com> <20130206192544.GH2148@tuxdriver.com> <511C1745.4000502@gmail.com>
In-Reply-To: <511C1745.4000502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2013 11:44 PM, Xose Vazquez Perez wrote:

> Serbia is under ETSI/CEPT rules( ECC/DEC/(04)08 ), see summary[1]:
> 
> 5 GHz current rules are too much liberal and incomplete:
> 
> country RS:
> 	(2400 - 2483.5 @ 40), (N/A, 100 mW)
> 	(5150 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR
> 	(5470 - 5725 @ 20), (3, 1000 mW), DFS
> 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
> 	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR

> They should be changed to "standard" ETSI rules:
> 	(2400 - 2483.5 @ 40), (N/A, 100 mW)
> 	(5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
> 	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
> 	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
> 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
> 	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR

sorry,

5150-5250 should be 200 mW:
 	(5150 - 5250 @ 40), (N/A, 200 mW), NO-OUTDOOR

<http://www.erodocdb.dk/Docs/doc98/official/pdf/ECCDEC0408.PDF>

2. that in the frequency band 5.150-5.350 MHz, WAS/RLANs stations
shall be restricted to indoor use with a maximum mean e.i.r.p. of
200 mW and a maximum mean e.i.r.p. density of 10 mW/MHz in any 1MHz
band;
