Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:38319 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab1KLVKN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Nov 2011 16:10:13 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RPKq1-0000N3-QV
	for linux-wireless@vger.kernel.org; Sat, 12 Nov 2011 22:10:09 +0100
Received: from 5ED0428A.cm-7-1b.dynamic.ziggo.nl ([94.208.66.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 12 Nov 2011 22:10:09 +0100
Received: from jfcmdejongh by 5ED0428A.cm-7-1b.dynamic.ziggo.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 12 Nov 2011 22:10:09 +0100
To: linux-wireless@vger.kernel.org
From: Jan de Jongh <jfcmdejongh@gmail.com>
Subject: Re: 802.11p implementation...
Date: Sat, 12 Nov 2011 21:01:06 +0000 (UTC)
Message-ID: <loom.20111112T202645-807@post.gmane.org> (sfid-20111112_221024_420473_825EFCFA)
References: <CAFtRNNwXdeBfa-mFNyAVALgTxM-wrUthgMLS18VokqOSSiWPqg@mail.gmail.com> <1320585006.11133.2.camel@jlt3.sipsolutions.net> <CAFtRNNxGd7NSmjNhZboW5VOZ++j=D1E_G6E6RqXLA3Ssuu4XfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis <mickflemm@...> writes:

> 
> 2011/11/6 Johannes Berg <johannes@...>:
> > On Sun, 2011-11-06 at 02:53 +0200, Nick Kossifidis wrote:
> >> It seems a group of people have released an 802.11p implementation on
> >> top of 2.6.31.
> >>
> >> http://www.gcdc.net/mainmenu/Home/downloads/Technology
...
> > johannes
> >
> 
...

Hi Nick, Johannes,

First, please note that I haven't checked on recent ath5k support for 802.11p.
If such support it already present, this mail is quite obsolete :-)...

The Grand Cooperative Driving Challenge succesfully used 802.11p in
vehicle-to-vehicle communications and vehicle-to-infrastructure communications,
using a modified ath5k driver (which you found on the gcdc.net site).
Apart from GCDC, there are many research and commercial projects/products
(SPITS/FREILOT/...) using patched ath5k drivers for half-clock-rate operation,
ocb, and access to the 5.9-6.0 GHz frequencies.
And there are many more to come,.
Simply because Atheros-based cards are among the few
(if not the only ones)
that support 802.11p/5.9GHz operation.
For GCDC, the patches had their origins in the CVIS project,
and in work by Eric Koenders of Peek Traffic.

However, the current situation is far from ideal...
By now, the 11p amendment has been ratified,
but maintaining 802.11p support for contemparory kernel/compat-wireless combos
is near to impossible without structural support from ath/ath5k developers.
The result of this effort, in short, would mean 802.11p operation
through module parameter and crda/regdb settings only,
and without the need to (re)compile kernels and/or kernel modules.
11p Operation would simply imply some configuration efforts
on well-known distributions (modules,conf, regdb/crda, iw, and stuff like that)
out-of-the-box...
I understand that there are regulatory issues
(crda, do we want anyone to operate on the ITS frequencies???) involved,
but we would be very interested in
structural 11p support in the ath5k driver (and, perhaps ath9k).
"We" referring to a substantial part of the ITS community.
If you can arrange substantial commitment to 11p support in ath5k,
I can mobilize people and funding for
development/testing/deployment/discussion/feedback.

Let me know what you think of this, best wishes,

Jan de Jongh
GCDC - Technology Leader

