Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51672 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbYGOH36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 03:29:58 -0400
Subject: Re: [PATCH 1/2 V2] mac80211: pass dtim_period to low level driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1216061040-954-1-git-send-email-tomas.winkler@intel.com>
References: <1216061040-954-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oUi94vvPxKL7ah/K6TSc"
Date: Tue, 15 Jul 2008 09:29:54 +0200
Message-Id: <1216106994.23746.12.camel@johannes.berg> (sfid-20080715_093001_523257_36B2A359)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oUi94vvPxKL7ah/K6TSc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-07-14 at 21:44 +0300, Tomas Winkler wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>=20
> This patch adds the dtim_period in ieee80211_bss_conf, this allows the lo=
w
> level driver to know the dtim_period, and to plan power save accordingly.
>=20
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

except you have a typo (see below) but I don't really care too much.


> +	/* set default value for bugy APs */

buggy :)

johannes

--=-oUi94vvPxKL7ah/K6TSc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIfFHtAAoJEKVg1VMiehFYuTsQAK9HZG+3SDjXo9dR3JgaI0ZW
zcPorOuCrN9LlvcDO8h1v46zZ20I5Vo5VbRC79NJ6bsBX1LTos3FVEtV1uS4Uuqc
NxzX29448KgYX+dkMGbWAjOKigsl82Rs3mhNl/Ov9T8cTQjalt2WXcIf1gVAgzOg
zIz1R9m2nSlFwbN7iYFhpQDKNxH/GsO5utUHYJVhCZQ2y+a4EyTGg6gfJZBLqbP9
NWJ0zPXSvHikuKQ/0GV6EymbKpZajbBKF9FkkVsoeSIJ7wnuutydOPK0k3VHGPd3
JSSd/7ObLDJlfVokJO5jVPfeR4YDPQF4limg5wwLYLmHBRTSFNda3VdL9aKPjEzr
ZnXHh8ITU+BIEp8XVcJ+aJd14/sIJ6nAlLejjXVi28+nipvd77Y2LXQPq2/05pig
h3rj6rpL1tukdx8Z4jLc8PSbr8ZWYWezawhuOE29g62h3/Ve8bfDY/heR1+Ubu9L
597j7Df2zLNvel49OdGZ3VsMwcpa3hEOUtBq0fiIlcziG0nDg5tkRvfLqnkRKPMg
pQUclnq+qcSbN32J7LqBm1usyipdQ5Bdqsj3LYuxWZXi3JJtVTRW6Ff6972oBj2w
wNJ4uW9vd3m8x8Ve8SBKZSVtS8NG04H6HntK9q2BNUR+YDrJ1FIRqu6EvdKpJNnh
TAO93OazOQfn23/dn8WT
=D2Nn
-----END PGP SIGNATURE-----

--=-oUi94vvPxKL7ah/K6TSc--

