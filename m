Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:48955 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab0FAUeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 16:34:24 -0400
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: Johannes Berg <johannes@sipsolutions.net>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 01 Jun 2010 22:24:45 +0200
MIME-Version: 1.0
Subject: Re: Association problems - again - comment
Message-ID: <4C056C8D.28708.54B184@jafojtik.seznam.cz>
In-reply-to: <1275422985.3634.22.camel@jlt3.sipsolutions.net>
References: <4C02E1CA.10757.239262@jafojtik.seznam.cz>, <4C055FA2.23990.223BFA@jafojtik.seznam.cz>, <1275422985.3634.22.camel@jlt3.sipsolutions.net>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Johannes Berg,

> > I have found a solution for my problem.
> > 
> > Patch from "Johannes Berg <johannes.berg@intel.com>" fixes a problem.
> > 
> > #Processing an association response could take a bit
> > #of time while we set up the hardware etc. During that
> > #time, the AP might already send a blockack request.
> 
> That makes no sense at all -- ath5k doesn't do aggregation. I guess it
> probably just means that your problem is timing related.
But it works ;)

May be, I do not know ATH5k internals.

I could test something, when you generate some release.

Anyway, the "workable" code still has reverted patch:
> You said you reverted 6b5d117eddc09cd976ad8030d715f4 and still have the
> problem, right?  Are you sure you booted the kernel with the revert?

So 2 changes against "compat-wireless-2010-05-30" has been done.

regards
   Jara
