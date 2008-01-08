Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:48101 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYAHUDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 15:03:53 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Date: Tue, 8 Jan 2008 21:02:16 +0100
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Ivo van Doorn" <ivdoorn@gmail.com>, chris2553@googlemail.com,
	linux-wireless@vger.kernel.org
References: <200712290942.37396.chris2553@googlemail.com> <1199812976.6762.7.camel@johannes.berg> <1ba2fa240801081143y52e92c62o8ee2c3e701df7919@mail.gmail.com>
In-Reply-To: <1ba2fa240801081143y52e92c62o8ee2c3e701df7919@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801082102.16682.mb@bu3sch.de> (sfid-20080108_200358_053158_88E55055)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 08 January 2008 20:43:53 Tomas Winkler wrote:
> On Jan 8, 2008 7:22 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> > On Tue, 2008-01-08 at 18:09 +0100, Johannes Berg wrote:
> > > > I didn't test the copy solution yet but in 11n rates I see as a show
> > > > stopper. All 11n packets are QoS packets.
> > >
> > > Really, go fix your firmware.
> >
> 
> I don't think it is really broken.  The packet it self is aligned. I'm
> not sure who has to be responsible for payload alignment you may have
> 10 other protocols packed into it,  each with variable length
> unaligned header.

Yeah sure. You can move data around in the kernel and waste CPU,
or you can be clever and let the NIC firmware do it. Whatever you want
at intel. It's up to you. ;)

-- 
Greetings Michael.
