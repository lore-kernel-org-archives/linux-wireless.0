Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.239]:16214 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYAHTny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 14:43:54 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1909793nze.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2008 11:43:53 -0800 (PST)
Message-ID: <1ba2fa240801081143y52e92c62o8ee2c3e701df7919@mail.gmail.com> (sfid-20080108_194400_675104_3D42F021)
Date: Tue, 8 Jan 2008 21:43:53 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>, chris2553@googlemail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1199812976.6762.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200712290942.37396.chris2553@googlemail.com>
	 <200712291614.55732.IvDoorn@gmail.com>
	 <1199261473.4172.58.camel@johannes.berg>
	 <200801022012.52287.IvDoorn@gmail.com>
	 <1ba2fa240801080744u5a076202n91f11b0de87384f8@mail.gmail.com>
	 <1199812167.6762.1.camel@johannes.berg>
	 <1199812976.6762.7.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 8, 2008 7:22 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2008-01-08 at 18:09 +0100, Johannes Berg wrote:
> > > I didn't test the copy solution yet but in 11n rates I see as a show
> > > stopper. All 11n packets are QoS packets.
> >
> > Really, go fix your firmware.
>

I don't think it is really broken.  The packet it self is aligned. I'm
not sure who has to be responsible for payload alignment you may have
10 other protocols packed into it,  each with variable length
unaligned header.

> I meant to write more here but accidentally deleted parts when
> restructuring. The firmware should insert padding to make sure the
> payload is aligned on a four-byte boundary at all times when the start
> of the DMA area is aligned that way.
>
I understand that  I'll see what can be done, yet I don't like it

Tomas


> johannes
>
