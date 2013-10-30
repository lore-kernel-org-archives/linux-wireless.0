Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3J3IEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 04:04:14 -0400
Message-ID: <1383120246.13488.2.camel@jlt4.sipsolutions.net> (sfid-20131030_090421_905013_A15B5F06)
Subject: Re: iwlegacy (4965) - what would 0x8000 as the completed TX rate
 indicate?
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 30 Oct 2013 09:04:06 +0100
In-Reply-To: <CAJ-Vmom0P7bJYWtCAYfCBKmMhhGHnqpf51mwPn0xkgyS84Qt=A@mail.gmail.com> (sfid-20131030_045936_726824_714A6878)
References: <CAJ-Vmok4rDn1Q5qCU2Oz=CVsqkJvYC0D+CmQL+WpwU+9qKHzrw@mail.gmail.com>
	 <1382968966.17956.15.camel@jlt4.sipsolutions.net>
	 <CAJ-Vmomsv52xc6-rwaBy9aZUsN3BaPeRTDBu8+bn2ov_Asb=1A@mail.gmail.com>
	 <1383033823.14377.1.camel@jlt4.sipsolutions.net>
	 <CAJ-Vmom0P7bJYWtCAYfCBKmMhhGHnqpf51mwPn0xkgyS84Qt=A@mail.gmail.com>
	 (sfid-20131030_045936_726824_714A6878)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-29 at 20:59 -0700, Adrian Chadd wrote:
> On 29 October 2013 01:03, Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> >> Well, what's rate=0 mean?
> >>
> >> And 0x8000 is bit 11 set, which is HT40. I definitely don't have HT40 enabled.
> >
> > 0x8000 is bit 15 set, which means "antenna B", I think?
> 
> Duh, sorry. was tired. :(
> 
> > But then I can't seem to figure out what rate=0 means either. Should be
> > an OFDM rate (bit 9 not set) but 0 isn't a valid OFDM rate value. Hmm.
> 
> That's why I'm confused too.
> 
> I'm seeing some odd behaviour here where sometimes the NIC behaves
> fine, and sometimes it just gets long transmit failures on OFDM frames
> but is fine with CCK frames. That's why I'm digging into this.
> 
> I also see the sensitivity tuning code lose the plot over time as OFDM
> errors are returned by the receiver and it keeps trying to compensate
> until it's maxed out the sensitivity tuning parameters. If I restart
> the NIC, it all comes back to normal for a while.
> 
> Do any of these ring a bell?

Sorry, no.

johannes

