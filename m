Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYLEJyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 04:54:05 -0500
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <rogge@fgan.de>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Henning Rogge <hrogge@googlemail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812051051.52908.rogge@fgan.de>
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812050934.07182.rogge@fgan.de> <1228470310.3970.13.camel@johannes.berg>
	 <200812051051.52908.rogge@fgan.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gc8R/ptQnkiVpZSsQc1D"
Date: Fri, 05 Dec 2008 10:54:00 +0100
Message-Id: <1228470840.3970.15.camel@johannes.berg> (sfid-20081205_105410_775625_EDBEB47E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gc8R/ptQnkiVpZSsQc1D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-05 at 10:51 +0100, Henning Rogge wrote:
> Am Friday 05 December 2008 10:45:10 schrieb Johannes Berg:
> > > Ath9k has it's ***_ratetable which contains a line of data for each
> > > transmission range. 20/40Mhz and guard interval is already contained =
in
> > > this table (encoded in "phy" variable). Just the MCS number is missin=
g.
> >
> > Well, yes, but it's not done uniformly across drivers.
> >
> > > And I think the intel driver has the necessary data too. If I underst=
and
> > > the iwl5000 driver, it pushes the rate index (even for 802.11n) throu=
gh
> > > ieee80211_rx_status into mac80211.
> >
> > Sort of, yes, but again, in a much different way. We really have to
> > rename struct ieee80211_tx_rate to struct ieee80211_txrx_rate and embed
> > it into struct ieee80211_rx_status for doing this properly.

> How many 802.11n capable drivers exist in mac80211 at the moment ?

Only those two, really, but more are in development, for example ar9170
and rt2800.

johannes

--=-gc8R/ptQnkiVpZSsQc1D
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJOPo0AAoJEKVg1VMiehFYypAQAJtgf5Vs7YezX+5taTlOmKPd
IpnhXReeoQdlAovyoFfxm/8Sc/J2WUrD9GlO6nFB52HCWNNWX3g8m68kfQlI3BMg
Hhwh4tgsf2j2qXH8rnYFCB5hfvzJp9rBrsu6chICc+47AG+CsNYK8JyisM02OKFO
riAQTNgWfUvAcqGIfbnjCvY0oZVaXvOCJxVuFCP58XDQ3DoV8DYzfQP8yM439rYi
8AZnR41HwYNr2c7mG5wqEE6fIeJ/58X1qgyKbm0zlQkrxsqmN6UinxI0L1Mm6CiP
wEcyorKb2BlWCe8YdbX6WM9iaLBkPMZ41g0o7+/aaXrmoRPcI5xABnkVkvHFQXE/
WvlOUOC+lV4x4zNrOW4rhD9nLjvNNzf4WSBxITX0Uk8/KQtdL07ydgKj6BXItHTO
ygswB2pgvws4NLKHfm8UlTShRk56Ld852IPdlAxfIatywGo8iqKfnIgFe7xzVQX+
IoBuCqCqBsl/Ub8zuEbUU3qSr1uNXVImA8Guwd/v4BmgWptkTtWYYLmrY+VVPw66
5N2rqsAj+l6QMm0zYgrl/UO80mh3EaJyU/gLiaz7qXUWbavmykcOo79LOOQssd4u
t1r/tcTuWDINhn8lmmWZHtIlimiogmJ7/l0strAQPJtjSUseU3R5EGiWU95gqMEH
AlYtypOSbVX7Uiwr1gNX
=Z4Zn
-----END PGP SIGNATURE-----

--=-gc8R/ptQnkiVpZSsQc1D--

