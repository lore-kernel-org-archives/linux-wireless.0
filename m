Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbYJUVZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 17:25:30 -0400
Subject: Re: New iwlwifi 3945 uCode available
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1224613633.10863.43.camel@rc-desk> (sfid-20081021_202700_149655_8ACA52AF)
References: <1224613633.10863.43.camel@rc-desk>
	 (sfid-20081021_202700_149655_8ACA52AF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SLYLUjW9u+z5h6/RVxd0"
Date: Tue, 21 Oct 2008 23:25:24 +0200
Message-Id: <1224624324.28639.9.camel@johannes.berg> (sfid-20081021_232534_514112_088DDA54)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SLYLUjW9u+z5h6/RVxd0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 11:27 -0700, reinette chatre wrote:
> Two new versions of 3945 uCode is now available for download from
> http://intellinuxwireless.org/?n=3DDownloads. Two versions are available
> as we have updated the API version of the uCode and included pending
> fixes in both API versions.
>=20
> Version 15.28.1.8 supports API v1 and can be used with most current 3945
> drivers. Version 15.28.2.8 (API v2) is required when you start using the
> latest 3945 driver from wireless-testing at the time it includes the
> patch "iwl3945 : Fix a-band association for passive channels".

Can you make the driver work with the old ucode? We even do that for
drivers where we don't control the ucode like b43...

johannes

--=-SLYLUjW9u+z5h6/RVxd0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/kjBAAoJEKVg1VMiehFY8agP/27n0UyiS4MM/TQSkrgzcJK8
9hB3jeO9K5d+xxA+vftFt+3kf+hqOHz/W5hH85V8gVf+nP2l+RyHroKJ+YVDVYGd
puhcleLQdTencSHjXNUxwdtHDomrRnr3+NZWI4cq343zurmS95WTS5+qXRQx20Na
H8OA6OSY6e3B/ePuKjsmyGt7kqfQVi5U9ThoeEQk35I7JHVgXEHsk9+KyId++Ufg
elyM6nsTurqsN0E04ktxEDLUCpb9w8td0TXka3H7gjfJHRzAALz8tBIVCWlXBj7T
WEp7RxsfnRrTpSX3uMI+8Nd42mSCxIa6s42uLtEIYWs5jBDHZJNN6cdV8jcpDw/0
4OFxg8Ah3t0/mHstI8E+QV88LZgL05Zeryul86tQ2IrQohhUxi6w0LnHbi2pu3x0
Ugkqt8j6RzU4ySpqeh44mZG5dHvzocyiZc4JmvEN2I0thmTGnCLK5rRuQVay9ZTh
hp/zytdrHDS0jXjoxQQX/TdBTqrQSRHBeSDZTM2Fz/NCFkCH9y8MXuNacn0Xo+kS
jdWrijK2dI219omav+mHNENjo6nw7Uf+m2jhBQ/7GOCuKNs3Fmywf1GFJre0HQk9
7OQDQWcKaJzOFlB6qFAM6vKsT8U2pdgvN/RD8AKbhSCkw/esFkuO2gjAF4XMlVoX
dp05G+alGaz1I2PA9tnJ
=2qWx
-----END PGP SIGNATURE-----

--=-SLYLUjW9u+z5h6/RVxd0--

