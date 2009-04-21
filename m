Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38227 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZDUNAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 09:00:52 -0400
Date: Tue, 21 Apr 2009 08:51:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] mac80211 powersave work
Message-ID: <20090421125132.GC17805@tuxdriver.com> (sfid-20090421_150055_977092_2820163D)
References: <20090416111723.904720021@sipsolutions.net> <20090420194430.GG3369@tuxdriver.com> <1240257188.4632.19.camel@johannes.local> <87ocuqfuk3.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87ocuqfuk3.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 21, 2009 at 08:24:28AM +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> >> I'm not sure I understand.  Your patch (which would go to 2.6.31)
> >> has it turned-on by default.  Which way do you want it?
> >
> > I want it turned on by default, at least in wireless-testing; Kalle
> > thinks that we should turn it off for a .31 release.
> >
> > I would think that since an easy workaround is available ("iwconfig
> > wlan0 power off") and it doesn't affect most hardware yet anyway (only
> > those supporting powersave) we should turn it on by default anyway,
> > since otherwise we won't find any bugs -- but maybe that's just me.
> 
> Yes, in my opinion the power save should not be enabled by default for
> the big masses, at least not yet. My understanding is that only few
> people have tested it and I would like to see more testing first. 
> 
> But if you (Johannes&John) think it's ready for the prime time, I'm not
> going to complain :)

Well there is always a trade-off.  But by the time 2.6.31 come around
the code will have been in wireless-testing, net-next, and linux-next
for a reasonably long time.  Hopefully we will have good confidence
in it by then.  If not, then we can disable it by default later.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
