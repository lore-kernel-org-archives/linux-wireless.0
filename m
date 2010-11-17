Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab0KQVIz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 16:08:55 -0500
Subject: Re: Bringing up Marvell 88W8300
From: Dan Williams <dcbw@redhat.com>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	dwmw2@infradead.org, David.Woodhouse@intel.com
Date: Wed, 17 Nov 2010 15:07:57 -0600
In-Reply-To: <AANLkTinKMfu2SX2fymUDi3JooAwKZv7=41BQBywR3pVe@mail.gmail.com>
References: <AANLkTik+BWQdU4hhKN7yfgOdJuQXopvYr4Z59RTntqSW@mail.gmail.com>
	 <1289607742.21000.23.camel@dcbw.foobar.com>
	 <AANLkTi=1RFZwRYvA=VfuKTQS6YwZkTv17Q0nnWnQW3Hq@mail.gmail.com>
	 <AANLkTinKMfu2SX2fymUDi3JooAwKZv7=41BQBywR3pVe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1290028078.8522.62.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-17 at 20:15 +0300, Denis Kirjanov wrote:
> >
> > I will try to load the firmware that comes with the driver source.
> >
> >> Does that sound like a plan?  I have no time for it, but I'm happy to
> >> put the driver up somewhere that others can make use of it.  I'll
> >> recheck the provenience of the driver but it's got MODULE_LICENSE("GPL")
> >> and GPL headers all over, including on the firmware file.  I might have
> >> grabbed it off the Extranet but I'll check.
> >>
> Marvell firmware is OK for me and I can successfully boot in .
> I believe that we can now port driver to the new wireless stuff such
> as cfg80211.

Yeah, that's the driver, the MSI thing or whatever linked from openwrt
forums.  Basically, I think we should get that driver working so we know
that *something* works on these cards, and then use it and mwl8k as a
guide to writing a new mac80211 driver for the 8335.

Dan


