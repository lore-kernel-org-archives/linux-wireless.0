Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44045 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab0LJTIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 14:08:44 -0500
Subject: Re: b43 N PHY status report
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
In-Reply-To: <AANLkTik2MdDg4g4dFuB6ozZ3Pp3pPORmSAxRAbtznTLP@mail.gmail.com>
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
	 <AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
	 <4CFFA112.7030800@lwfinger.net>
	 <885729A3-72D4-4EFC-AAFE-D2B573E00ED9@ing.unibs.it>
	 <1292006874.3531.4.camel@jlt3.sipsolutions.net>
	 <4D02793E.2050004@lwfinger.net>
	 <AANLkTik2MdDg4g4dFuB6ozZ3Pp3pPORmSAxRAbtznTLP@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 20:08:40 +0100
Message-ID: <1292008120.3531.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-10 at 20:04 +0100, Gábor Stefanik wrote:
> On Fri, Dec 10, 2010 at 8:02 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > On 12/10/2010 12:47 PM, Johannes Berg wrote:
> >> On Fri, 2010-12-10 at 19:30 +0100, Francesco Gringoli wrote:
> >>
> >>> [ 1117.516031] unregister_netdevice: waiting for wlan1 to become free. Usage count = 1
> >>>
> >>> and the device is never release (by who?). I have to reboot.
> >>
> >> That's a bug in the ipv6 code, upgrade your kernel :-)
> >
> > I would not have seen that as IPv6 is disabled in my kernels.
> 
> Are you serious? Disabling ipv6 with ipv4 exhaustion expected in January?

Can we stop this thread right here and go on-topic again please?

johannes

