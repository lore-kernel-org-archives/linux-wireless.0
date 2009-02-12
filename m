Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47180 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbZBLVcD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 16:32:03 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 13:32:02 -0800
Date: Thu, 12 Feb 2009 13:31:16 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Michael Green <Michael.Green@Atheros.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Alberto Pollastro <a.pollastro@gmail.com>
Subject: Re: [ath9k-devel] Radar Detection and DFS status
Message-ID: <20090212213116.GI4196@tesla> (sfid-20090212_223207_376912_60768F92)
References: <2d14e2ca0902110900r7f0b84e4k7be81827187c434@mail.gmail.com> <43e72e890902111341l36bd40c8o9d54515e8b06e603@mail.gmail.com> <17a838c40902120456wb862200y8717a0d6a061b057@mail.gmail.com> <43e72e890902120753w44cab825i861d5c92c4816c61@mail.gmail.com> <17a838c40902121239v48bb2657jb540e52520b59a56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <17a838c40902121239v48bb2657jb540e52520b59a56@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 12:39:51PM -0800, Alberto Pollastro wrote:
> On Thu, Feb 12, 2009 at 4:53 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > Yes, we have indoor and outdoor channel flags. You can supply a patch
> > or provide a reference to the regulatory information you are reading
> > to determine this and we can patch it up.
> 
> I've read the European Directive 2007/90/EC:
> 
> http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2007:041:0010:01:EN:HTML
> 
> I think that the EC directive has been acknowledged by the Italian
> legislation as reported in the following table at page 28 (it's in
> Italian, sorry):
> 
> http://www.comunicazioni.it/binary/min_comunicazioni/piano_nazionale_ripartizione_frequenze/03%20tabella_B.pdf
> 
> I hope I'm not wrong.

Thanks the details, Michael, what do you think?

  Luis
