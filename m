Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53336 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbYBAMnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:43:05 -0500
Subject: Re: wireless mini-summit agenda proposals?
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1201801923.3000.13.camel@localhost.localdomain> (sfid-20080131_175252_912444_0BC17431)
References: <20080131162514.GC6413@tuxdriver.com>
	 <1201801923.3000.13.camel@localhost.localdomain>
	 (sfid-20080131_175252_912444_0BC17431)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ywk4a+II6cI55LlDTXu/"
Date: Fri, 01 Feb 2008 13:42:30 +0100
Message-Id: <1201869751.4188.19.camel@johannes.berg> (sfid-20080201_124311_472957_E1BD484C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ywk4a+II6cI55LlDTXu/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> cfg80211/nl80211 - overview, get Johannes to disseminate knowledge
> because email isn't optimal for this.  I haven't had enough time to jump
> into it yet, but the fact that Johannes is the vast majority of the
> effort here is worrisome.  Having a reference implementation (airo,
> atmel, maybe libertas) of a fullmac driver ported to cfg80211 would
> probably be very useful, even just to get a sense of how the API works.

cfg80211/nl80211 is no further for fullmac drivers than a year ago, all
work it got so far is for hostapd.

I have a fairly decent plan how to add association/... support but it
lacks execution because it's completely boring work that doesn't buy us
any new features since we still have to support wext.

> 802.11n - do we need any discussion here or is it just a question of
> executing on the current plan?

I think with the last patchset from Ron it's mostly done, cleanups still
to do and probably QoS improvements (I'm thinking multiqueue netdevs
here)

> Userspace MLME - what's going on here?  Noise around this seems to be
> quieter these days.  Is stuff going according to plan/schedule or are
> there roadblocks?

Nobody is working on this, but a good part is done since hostapd works
and the userspace MLME needs many of the same features. Again, the
biggest thing is cfg80211/nl80211 support, setting a device to userspace
MLME mode and implementing the communication.

johannes

--=-Ywk4a+II6cI55LlDTXu/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6MTtaVg1VMiehFYAQI81hAAqTfm9fhzK23yQsQ2jIo5BWmRoib23x5d
bLsKySgsgLhqL7kVA1vkTdZaS5bpNArQemTAiCB+i4OH3UV/T+VWBZag0kWx23tr
/Icetd314fCXl8FwwSZaoyppA30zMUnnxiywg4uNfeaiyrzm5Zbsjqil5UJ516pg
1u5bpfdTUdI3L0buQ+2y6zC9156VuYvtsYp8vVwctBBN491TNZvECAebaVkB3ZPO
YVlCe8TIjbmYNxVAtGTorJGWDuOpWyX5UjRphqrJV6PIFIVeff8W+4qjwXq9xBlh
09UrYZo8Ezcrw3jgsAOZFs436STM6/Pz/XHHd5SSQZUYAlI2FJVr9a3h+FGjb36c
aciE4bbB9jEOgGP9VTAB5e0+dFZkOKdv/UHCKha/XwdfUcCg3czfxQmK/H5RgmZz
ic2IjcmgpyJqxYuMTT2yGenbM5YBI0Wae9rPfCh3lsQ+wbvTLpasC6MBS5ABjJNX
YuwZb2eWG6SPXLGFpPi+jAUEowRFIvQjHO3WPDtyewFP4yJN34J3q8t1INYvAeXv
c4K+Ozbxxjnrm/s1j0eSLjVgiDee7drVyDkL1M7V5L3081FTbFPmdejn9eg57b08
Eu2JvTn22wHbZ/CtNNEaUtfAvTU4TDgfM/PmzQuHR8OFNXk4D1Mn0c8OdKXLqPxx
53TQ+yTfdxQ=
=OzJy
-----END PGP SIGNATURE-----

--=-Ywk4a+II6cI55LlDTXu/--

