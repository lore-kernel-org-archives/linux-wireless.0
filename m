Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48316 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357AbZAPUdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 15:33:08 -0500
Subject: Re: [PATCH 10/13] cfg80211: remove check for last_request on
	ignore_reg_update()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090116162731.GD29609@tesla>
References: <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-9-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-10-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-11-git-send-email-lrodriguez@atheros.com>
	 <1232097990.3854.31.camel@johannes>  <20090116162731.GD29609@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1CE+S9rQROIj19Bt0k1G"
Date: Fri, 16 Jan 2009 21:33:00 +0100
Message-Id: <1232137980.3745.3.camel@johannes> (sfid-20090116_213315_770003_294D7200)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1CE+S9rQROIj19Bt0k1G
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 08:27 -0800, Luis R. Rodriguez wrote:
> On Fri, Jan 16, 2009 at 01:26:30AM -0800, Johannes Berg wrote:
> > On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> > > There is no need to check for last_request as the callers of
> > > update_all_wiphy_regulatory() ensure its present.
> >=20
> > Are you sure? I had all this blow up all around me.
>=20
> Interesting -- well that's the thing, where and why would it have blown u=
p?
> I did test it and didn't run into it.

Only w/o crda and old-regulatory did I see that happen though, not sure.

johannes

--=-1CE+S9rQROIj19Bt0k1G
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcO75AAoJEKVg1VMiehFYISsQAK7ng+zDsIvXfjugLyvefzTd
6O3badYG0Ec6enkcIjlIHmFgEVN0jjWnVuj/H8pqfemFHr32Rv5WaH6oveqR4mK5
4IaQflxi+saPNMjFmdCbzdZQuDvfkELLJSgSq5HXNGmr/6H8/LpcprEYvX4Av6Aw
IHnGW8WbhjYDKBXcTRwPrGekJ8Jl0hbwGnW1tEb+KA32XMcRu7fY5DCxQytnpmcZ
XCNa8doL9fkXg1gUsIxeqVNWRTzixEDzTZa7Vyvtst6exkBg/IHEvaU5UrzCVyhW
3nUfl/xaJOOYqYPC/qISSgUnsEPDBB4Yrz01g/OHxVejqdHqnbCdTKXm7qkU7l6m
wMrA/JH+iVT51wdPsCP0d8hAWG7AF+tcoeyXrgIA+C83dcWEbBhOcp4/+XySJEJW
MiUvdv22AAyiITusbxUkIHmoSXpYS866XVzIkT9bMnGtjE/NcesvM1grAJZc3n/j
RMPvoE2cUHTnPcXsfKRosJfbiBkVLNCrCcN/tq3fpfY02tiQL4Lk0kqLZ9jVKLLe
2r1mNkKsA6NMQl2KecmRbfhC+xLWdNrXch/8kA5B5rVU2AV8DFzPobdE8NE3AbEc
zZX4zCh8BNYLrS5L43/mo5w09wJSygZD0vF5SN4hl1EvBIqX2f7DtGafr0BAr5MC
OhfHOqfswzV/vhj7yrBd
=5l+j
-----END PGP SIGNATURE-----

--=-1CE+S9rQROIj19Bt0k1G--

