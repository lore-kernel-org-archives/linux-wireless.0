Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:57882 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbYFEV2Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 17:28:24 -0400
Subject: Re: Glossary for all words
From: Pavel Roskin <proski@gnu.org>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Joe <wirelesss@gmx.de>, linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910806051421m17efed1andf82b62246ca9f02@mail.gmail.com>
References: <4848577F.50802@gmx.de>
	 <69e28c910806051421m17efed1andf82b62246ca9f02@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 05 Jun 2008 17:28:22 -0400
Message-Id: <1212701302.30431.20.camel@dv> (sfid-20080605_232827_526643_F5EE86E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-05 at 23:21 +0200, Stefanik G=C3=A1bor wrote:
> A few corrections:
> On Thu, Jun 5, 2008 at 11:15 PM, Joe <wirelesss@gmx.de> wrote:
> >
> > Hey guys,
> >
> > first of all I want to tell you all my commendation for your fine w=
ork. Right now I'm reading your source code to understand your code. In=
 the future I'm interested in extending (may be I would have to hack so=
mehow) your code. Currently I'm most familiar with upper level usage of=
 WLAN - especially Ad Hoc mode. Now I got a possibility to dig into the=
 linux kernel and into the maclayer of WLAN for the next years / month =
during my phd thesis. During reading I got some problems understanding =
some of the abbreviations in your code.
> > Thereby I was thinking a glossary for your framework could be helpf=
ul for future newbies.
> >
> > Would you like to help me withit?
> >
> > Abbrev: English / German
> > If: Interface / Schnittstelle
> Correct.
> > Tx: Transmitter / Sender
> It can also be just "Transmit".
> > Rx: Receiver / Empf=C3=A4nger
> Again, can be "Receive.
> > STA: State / Status
> No. STA=3DStation. AP=3DAccess point, IBSS=3DAd-hoc, and finally MON =
and
> MNTR stand for Monitor. These are interface types.
> > skb: ?
> That's something I can't decipher, either...

Socket buffer, according to
=EF=BB=BFhttp://vger.kernel.org/~davem/skb.html

> > ops:
> I don't know this either, maybe operations or output sequence...

operations

> > rtnl:
> Hmm... maybe real-time netlink?

routing netlink, according to net/core/rtnetlink.c

> > pid: Process id
> No, proportional-integral-derivative.

http://en.wikipedia.org/wiki/PID_controller
It's the default rate control algorithm in mac80211

--=20
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
