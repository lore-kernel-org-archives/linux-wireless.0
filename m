Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:35854 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYAHXSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 18:18:21 -0500
Received: by wa-out-1112.google.com with SMTP id v27so16078wah.23
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2008 15:18:20 -0800 (PST)
Message-ID: <1ba2fa240801081518h2ec5f43exe3878d532456348a@mail.gmail.com> (sfid-20080108_231837_866028_621B5623)
Date: Wed, 9 Jan 2008 01:18:19 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Ivo van Doorn" <ivdoorn@gmail.com>, chris2553@googlemail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <200801082102.16682.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200712290942.37396.chris2553@googlemail.com>
	 <1199812976.6762.7.camel@johannes.berg>
	 <1ba2fa240801081143y52e92c62o8ee2c3e701df7919@mail.gmail.com>
	 <200801082102.16682.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 8, 2008 10:02 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 08 January 2008 20:43:53 Tomas Winkler wrote:
> > On Jan 8, 2008 7:22 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > >
> > > On Tue, 2008-01-08 at 18:09 +0100, Johannes Berg wrote:
> > > > > I didn't test the copy solution yet but in 11n rates I see as a show
> > > > > stopper. All 11n packets are QoS packets.
> > > >
> > > > Really, go fix your firmware.
> > >
> >
> > I don't think it is really broken.  The packet it self is aligned. I'm
> > not sure who has to be responsible for payload alignment you may have
> > 10 other protocols packed into it,  each with variable length
> > unaligned header.
>
> Yeah sure. You can move data around in the kernel and waste CPU,
> or you can be clever and let the NIC firmware do it. Whatever you want
> at intel. It's up to you. ;)

You are twisting my answer please read it again.
Frankly  I will try to fix it in FW but if not I rather fail on 2
platforms  then making 11n useless on 4 others.
Maybe we should ask some company to fix ther CPU to support unaligned
access. Or ask the guys that 'saved' two bytes in QoS field to change
the spec. Same goes for designers of 4965 that never dreamed someone
will stick it to SPARC machine. And I can bet the same goes for other
wireless HW companies.

Cheers, please don't replay to me  I''m really going to try fix it :)

Tomas


> --
> Greetings Michael.
>
