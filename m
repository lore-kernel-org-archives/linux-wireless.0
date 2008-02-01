Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.237]:53520 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbYBAS3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 13:29:20 -0500
Received: by wr-out-0506.google.com with SMTP id c48so1212609wra.23
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 10:29:16 -0800 (PST)
Message-ID: <1ba2fa240802011029h7cce3f77ge61bc11564c378a6@mail.gmail.com> (sfid-20080201_182923_924448_A98B8EE6)
Date: Fri, 1 Feb 2008 20:29:14 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: wireless mini-summit agenda proposals?
Cc: "Dan Williams" <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1201869751.4188.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080131162514.GC6413@tuxdriver.com>
	 <1201801923.3000.13.camel@localhost.localdomain>
	 <1201869751.4188.19.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 1, 2008 2:42 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > cfg80211/nl80211 - overview, get Johannes to disseminate knowledge
> > because email isn't optimal for this.  I haven't had enough time to jump
> > into it yet, but the fact that Johannes is the vast majority of the
> > effort here is worrisome.  Having a reference implementation (airo,
> > atmel, maybe libertas) of a fullmac driver ported to cfg80211 would
> > probably be very useful, even just to get a sense of how the API works.
>
> cfg80211/nl80211 is no further for fullmac drivers than a year ago, all
> work it got so far is for hostapd.
>
> I have a fairly decent plan how to add association/... support but it
> lacks execution because it's completely boring work that doesn't buy us
> any new features since we still have to support wext.
>
Security setting is a bit  broken. There is a missing separation
between static and dynamic./WPA wep keys.

> > 802.11n - do we need any discussion here or is it just a question of
> > executing on the current plan?

> I think with the last patchset from Ron it's mostly done, cleanups still
> to do and probably QoS improvements (I'm thinking multiqueue netdevs
> here)

Multiqueue  and  AP mode support is planed. AP mode requires changes
in configuration interface (cfg, wext) and hostapd.

> > Userspace MLME - what's going on here?  Noise around this seems to be
> > quieter these days.  Is stuff going according to plan/schedule or are
> > there roadblocks?
>
> Nobody is working on this, but a good part is done since hostapd works
> and the userspace MLME needs many of the same features. Again, the
> biggest thing is cfg80211/nl80211 support, setting a device to userspace
> MLME mode and implementing the communication.
>
> johannes
>
