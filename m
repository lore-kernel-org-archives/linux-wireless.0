Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:52614 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbcDSUMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 16:12:39 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Petko Bordjukov <bordjukov@gmail.com>
Cc: Maximilian Engelhardt <engelhardt@perisens.de>,
	seth.forshee@canonical.com, maxi@daemonizer.de,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [wireless-regdb] wireless-regdb: Update regulatory rules for	Germany (DE) on 5GHz
References: <1958820.LBuzOElZFT@perisens15>
	<87k2jt5rgz.wl-bordjukov@gmail.com>
Date: Tue, 19 Apr 2016 22:11:58 +0200
In-Reply-To: <87k2jt5rgz.wl-bordjukov@gmail.com> (Petko Bordjukov's message of
	"Tue, 19 Apr 2016 22:27:40 +0300")
Message-ID: <8737qh73zl.fsf@nemi.mork.no> (sfid-20160419_221243_190792_CF678175)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Petko Bordjukov <bordjukov@gmail.com> writes:

> Hello,
>
> Just to add my input to this thread. I've previously contributed the SRD ranges
> for Bulgaria, hopefully this info will provide pointers for research in other EU
> countries. Since then I've doublechecked the standards situation for Wi-Fi with
> the local communications regulation commission and one of the staffers there has
> given me an expert opinion (I would attach it, but it's a nasty HTML email in
> Bulgarian, if there's interest, I'd be glad to share and translate it).
>
> The gist on the SRDs is that in Bulgaria they fall under the following
> standards (which correspond to ETSI standards):
>
> BDS EN 300 440-2[0]
> BDS EN 300 674-2-2[1]
>
> Note that the first one is a harmonized standard (so in theory it should be
> universally adopted accross the EU) and the second one is a candidate harmonized
> standard (so you should check if it's already been adopted locally).
>
> As far as I could tell, BDS EN 300 674-2-2 defines the maximum e.i.r.p. for the
> SRD range but someone more knowledgable should take a look, too.

Ah, the references to those specs bring back memories of good times with
the European Tourism and Sightseeing Institute in the 90ies :) I
remember heated (but friendly) discussions in RES 8 about 300 674 for
years before it finally was published

Anyway, 300 674 is for vehicle transponder systems.  I.e. electronic
toll collection etc.  I don't think it's relevant to the regdb in any
way.

The generic SRDs covered by 300 440 are more relevant.  But this is
still not a license regulation.  It can probably be used as a harmonized
standard with reference to the Radio Equipment Directive, but licensing
is not in the scope AFAIK.  Spectrum utilization is not fully harmonized
in the EU.  So you have to look at the national regulations for every
country, even within the EU.

The ERC recommendation Maximilian linked to (
http://www.erodocdb.dk/Docs/doc98/official/pdf/REC7003e.pdf ) is much
more useful, since it is a collection of SRD licensing rules for all
CEPT countries. Which are much more than "just" the EU - 48 countries
now, according to http://cept.org/cept

But you'll still have to look into the actual national regulations.  In
my experience, the listed restrictions and conditions in appendix 3 of
ERC/REC 70-03 are often imprecise or incomplete.  It's definitely best
to do what you did: Talk to the local regulatory authorities.  I'm sure
most of them are more then interested in helping to improve the regdb.


Bjørn
