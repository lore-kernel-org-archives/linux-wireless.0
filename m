Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964AbZA1UhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 15:37:08 -0500
Subject: Re: [PATCH v2.6.29] iwlwifi: clean key table in
	iwl_clear_stations_table
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1233164310-22770-1-git-send-email-reinette.chatre@intel.com> (sfid-20090128_183539_794013_573635C8)
References: <> <1233164310-22770-1-git-send-email-reinette.chatre@intel.com>
	 (sfid-20090128_183539_794013_573635C8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-scaF4O3Gxb4OBGSjjAmp"
Date: Wed, 28 Jan 2009 20:05:37 +0100
Message-Id: <1233169537.16048.4.camel@johannes.local> (sfid-20090128_213729_623040_E4F45627)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-scaF4O3Gxb4OBGSjjAmp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-28 at 09:38 -0800, Reinette Chatre wrote:
> Cleans uCode key table bit map iwl_clear_stations_table
> since all stations are cleared also the key table must be.
>=20
> Since the keys are not removed properly on suspend by mac80211
> this may result in exhausting key table on resume leading
> to memory corruption during removal

Just FYI, this is fixed now in mac80211.

johannes

--=-scaF4O3Gxb4OBGSjjAmp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgKx+AAoJEKVg1VMiehFYfWAQAJS6r+ZQ3aF269F0UD9bTYRQ
EMZgSV/NwboeMcc6DqpJHt9gslHfh92A9SKdY3qpEM0qmWRkDmM10yRXbz9/sSqM
QfjXRohd+Ml4KYDvbTvpAhAaDY2OddGt26UrGj/ft43P4ogDkxszhbgYnfw99GcD
LCKovdgL4bDRlJ/AzMhjqW6qD1VP5AOJc8TxPCuXGRKregMCjhZkKrnM0OsoYKOi
ROsNDVPajrGe2tJDFTEMKDcZd6AYVfJ6EzEv38Dl+2H47qCSHQeezf+llLh/20pv
/TCmnm44gZiRmTCl/xTKTJe5dKy4dU4SGZGwFMVsUDbQxmNxGdV3/lI2cAXP1nca
uzIvM6s98E99AJwz4OKpZJzggl4ZtsU9nhfDaC+xyLqn4Y+yQk9pOzwY/DOrtPhn
owKV3Nna5kJbXadKA9tvV/ykRhUqKTg6SrQXIfpY3CDS+bobZBydxnfa2VGK5Ixa
fLiJ8Jor+KMCKQQm7+osdvH+H4jZmf6PNc08p24mFQJt/B6NNXwFoARghwgAeC4y
7fk4RRw39kzi7epdiojPHkas8xPEDCouJj/qFuk7uc7z8yDKnibbjXZEJEGyna4S
N6tfBAVJULnM1PyEKvKr/vziL2fBIeoJUKPT2D26d1SlJtYDAF5bz7CziNSH9ZWd
BCHYvYo+ZmWXFdoq9i+e
=kMe3
-----END PGP SIGNATURE-----

--=-scaF4O3Gxb4OBGSjjAmp--

