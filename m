Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64460 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbZAHXS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 18:18:28 -0500
Message-ID: <20090108231828.QHGIG.228066.root@hrndva-web20-z02> (sfid-20090109_001832_062022_9D980713)
Date: Thu, 8 Jan 2009 18:18:27 -0500
From: <lmage11@twcny.rr.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: Help debugging unexpected disassociations?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890901081506r7e38328apee3007b556db0cd3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---- Hin-Tak Leung <hintak.leung@gmail.com> wrote: 
> On Thu, Jan 8, 2009 at 10:43 PM,  <lmage11@twcny.rr.com> wrote:
> > ---- lmage11@twcny.rr.com wrote:
> >> Hey everyone. I'm using an Intel 4965AGN using the iwlagn
> >> driver in 2.6.28. When using a specific AP, my connection is
> >> unexpectedly dropping with nothing more than a
> >> "wlan0: deauthenticated". Any tips on how I could figure out
> >> whether this is the driver's fault or the AP's? Another problem I'm
> >> having is that dhcpcd is timing out a lot, usually after trying to
> >> reconnect from a connection drop.
> >>
> >> The AP is a Linksys WRT54Gv1 with WPA2 and ssid broadcasting enabled.
> >>
> >> Thanks!
> >>
> >> Ari
> >
> > Um... Bump?
> 
> It is no use and quite annoying to do that - it sounds like "read my
> mind and spoon-feed me". Your initial post has almost no useful
> information to speak of (actual log entries, wpa_supplicant config,
> whether using networkmanager or static config, etc).

Um.

Well considering as I'm not a developer and don't know how to debug
these things, I think "spoon-feeding" is an appropriate term, no? And
also, I didn't ask you to read my mind, I didn't even ask you to figure
out the problem for me, I asked for the information that I would need
to figure out the problem MYSELF. 

As for "useful information", the "wlan0: deauthenticated" is *LITERALLY*
all I get. I was not lying to you. After stripping out identifying information,
my wpa_supplicant config would be pretty much completely empty. The config
for this AP is about as simple as a consumer WPA2 AP config can be. I am not
using networkmanager.
 
> You probably should try to run wpa_suplicant in the foreground.

You mean so I can see the debug messages it outputs?

Ari
