Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:15258 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbYFEVVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 17:21:55 -0400
Received: by wf-out-1314.google.com with SMTP id 27so661261wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2008 14:21:53 -0700 (PDT)
Message-ID: <69e28c910806051421m17efed1andf82b62246ca9f02@mail.gmail.com> (sfid-20080605_232159_419950_458DF1DE)
Date: Thu, 5 Jun 2008 23:21:52 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: Joe <wirelesss@gmx.de>
Subject: Re: Glossary for all words
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4848577F.50802@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4848577F.50802@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few corrections:
On Thu, Jun 5, 2008 at 11:15 PM, Joe <wirelesss@gmx.de> wrote:
>
> Hey guys,
>
> first of all I want to tell you all my commendation for your fine wor=
k. Right now I'm reading your source code to understand your code. In t=
he future I'm interested in extending (may be I would have to hack some=
how) your code. Currently I'm most familiar with upper level usage of W=
LAN - especially Ad Hoc mode. Now I got a possibility to dig into the l=
inux kernel and into the maclayer of WLAN for the next years / month du=
ring my phd thesis. During reading I got some problems understanding so=
me of the abbreviations in your code.
> Thereby I was thinking a glossary for your framework could be helpful=
 for future newbies.
>
> Would you like to help me withit?
>
> Abbrev: English / German
> If: Interface / Schnittstelle
Correct.
> Tx: Transmitter / Sender
It can also be just "Transmit".
> Rx: Receiver / Empf=E4nger
Again, can be "Receive.
> STA: State / Status
No. STA=3DStation. AP=3DAccess point, IBSS=3DAd-hoc, and finally MON an=
d
MNTR stand for Monitor. These are interface types.
> skb: ?
That's something I can't decipher, either...
> wiphy: Wireless physical
Not exactly, it's Wireless PHY. A PHY is a physical-layer controller.
> ops:
I don't know this either, maybe operations or output sequence...
> vif: ? virtual interface
Exactly.
> hw: Hardware?
Yes.
> rtnl:
Hmm... maybe real-time netlink?
> pid: Process id
No, proportional-integral-derivative.
>
>
> When I will have understood the code, I'm interested in sending Beaco=
n frames 'manually' and during this step reconfigure the Beacon data re=
gularly...
>
> For now all the Best
> Sebastian
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
