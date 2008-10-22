Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49263 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbYJVTbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 15:31:16 -0400
Subject: Re: [PATCH v2] wireless: remove struct regdom hinting
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20081022122914.GH6190@tesla>
References: <1224585042.5521.7.camel@johannes.berg>
	 <20081022113950.GE6190@tesla> <1224701496.30459.50.camel@johannes.berg>
	 <20081022122914.GH6190@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AjyiToFV03ZxBKVAIPmI"
Date: Wed, 22 Oct 2008 21:31:09 +0200
Message-Id: <1224703869.30459.63.camel@johannes.berg> (sfid-20081022_213126_040894_4EB1E21B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AjyiToFV03ZxBKVAIPmI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 05:29 -0700, Luis R. Rodriguez wrote:
> On Wed, Oct 22, 2008 at 11:51:36AM -0700, Johannes Berg wrote:
> > -/* wiphy is set if this request's initiator is REGDOM_SET_BY_DRIVER */
> > +/* wiphy is set if this request's initiator is REGDOM_SET_BY_COUNTRY_I=
E */
>=20
> Why don't we want to keep track of the wiphy if the driver set it?

Why would we? I removed it from the hinting functions so that we don't
need to have a valid wiphy to call a hint, which seems quite possible?

johannes

--=-AjyiToFV03ZxBKVAIPmI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/396AAoJEKVg1VMiehFYEDQP/37RbKsWYNAQa90mhorh7Rcs
iXx8HwZIbpkR+ykq8qShbrbt4PK7lX5feCndzSjivMBIK38cSIIfiPIP6ZALRN15
J5OMx0fzhvYbrTyTT3ZQkEFwuEBbUplp31ntcGifFi3K9mLSi4CVt9WVmIiNhQA0
XBauyNUs0Uv6hyTZjnujxfeiiwKbJBMDWK0CmmYusaHTLwC026HL8i16F2yWlzlW
7iKO16dnV+dL0wel75z+iHttoLnRj1x+WhU5/BtliVxWAaScXt0tQ89ZF4pHSVHl
hGu+ocKl1K5hZgEWSGIqY/DFDX2NkDPxE5zNrMEEgKlAJE1Ly1issZhtbww52b2G
5RzrQyMYJhBdmnxd44uiHsvYd4eNL8SwrgYFk1gBDUNwS+32X+V4Wze9fbnhOtEm
ErNvy9awx6zeMX7J+MWM3j9MPDGkS5Bf2Wjev1Ycw87kDWcVgqPayWP304mpA43e
PGmIkZwPbxyEb+EH2XL5khrDNseOYw5+EqJqSim4D0YwFkOdsSSJ0NUJExjgfxkn
94PYnx4Hhp01KMkzib4c+K1b0uKag+oqZwnH4xXT4LdQRo7f+pwsf4ihxqDGXz3V
X5qg3RrqdkjO+7x37yEWSFLDOHh6SGePdYyLY7/ofwh8xkTqSTOZQJ6N0khQB/1z
OgwZCNqARNkuu2Ab2kVG
=Ryg0
-----END PGP SIGNATURE-----

--=-AjyiToFV03ZxBKVAIPmI--

