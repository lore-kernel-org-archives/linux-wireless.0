Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53418 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbZIAPzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 11:55:14 -0400
Subject: Re: [PATCH 5/7] wireless: update WIRELESS_EXT kconfig entry
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <4A9D436E.20509@lwfinger.net>
References: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
	 <1251818566-9264-6-git-send-email-lrodriguez@atheros.com>
	 <4A9D436E.20509@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-H71N8onA+fr7dINej0My"
Date: Tue, 01 Sep 2009 17:54:43 +0200
Message-Id: <1251820483.24846.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H71N8onA+fr7dINej0My
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-01 at 10:53 -0500, Larry Finger wrote:

> > @@ -98,8 +98,16 @@ config WIRELESS_EXT
> >  	bool "Wireless extensions"
> >  	default y
> >  	---help---
> > -	  This option enables the legacy wireless extensions
> > -	  (wireless network interface configuration via ioctls.)
> > +	  This option enables the legacy wireless extensions.
> > +	  Wireless extensions was the first 802.11 wireless configuration
> > +	  API used by the networking subsystem. You will not need this unless
> > +	  you have old userspace utilities or old wireless devices which
> > +	  have not yet been ported to cfg80211.
>=20
> I would like this to read "You will need this if you have old
> userspace utilities or old wireless devices that have not yet been
> ported to cfg80211."

Don't those "select WIRELESS_EXT" anyway so you don't have a choice?

johannes

--=-H71N8onA+fr7dINej0My
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKnUO/AAoJEODzc/N7+Qma0H0P/0PdDJV6pSHTww6MRqdOqw/M
R/CqdVxTInsLrKgTVRBwirakk2Th9SePiIbhLtwEQXwaWZQ3sNc0+jjUW3yZDUD2
3XZnHkcdsEGd8FCAeFxIvKg3qjBBmL4ClOn9W1winjEVHTeW4GV0xNoehJYEgQTK
Gc656lU4h7b+C5rKMv0i8IiUcBTo4Gw0/yA9cavaJNr6mH5NYFheUExQrah+L8w+
an3FCAAlqV4mg9yXKAFVdKoTmz91MW1Nq7kOznImdZ8BmU8rIrp5WEB/eXSEWIsW
ZzCNV8G3c599NCdTjz4vKMuEG4iogk4q72A3R2Obv+w4ozKx3ExBb/iyGDIRThDU
WlAesEyK5HiuGevACeBWbAb33T3c70zF0iRhoJebi/jlVcCgjIHKN8oXnRGSjCZy
sN4PMgm5ETBLtOFylSLxsC6nmtVWF8Hm5OJXGnugysyOaqb8dJriDpcpj+ZwayYb
05fjSUCXFU2n/rYKcUnHxuBzJINLC/l5FnnZOWXA7ZYBDLJNXaDejdXU7jOD+pb9
VhEI5kOVhS5S64a48Q1rVuxVQhAbaWyJ5ZaS8sbLoer9bc17p3GAcim6eflJMkvS
9Gw5PiDfg6rhcrD/N9vvFUadGcvi1Aw4kyuKjUCl56Ig0Fg3SfxMfvQYUUxD4xHc
PhINdCaleFg/ZNYU3Rpy
=i+ZP
-----END PGP SIGNATURE-----

--=-H71N8onA+fr7dINej0My--

