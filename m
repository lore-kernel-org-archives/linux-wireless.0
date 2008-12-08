Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYLHNTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 08:19:14 -0500
Subject: Re: [RFC v2] mac80211: fix HT channel selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Jouni.Malinen@atheros.com,
	Luis.Rodriguez@atheros.com, tomas.winkler@intel.com
In-Reply-To: <20081208131440.GA7365@jm.kir.nu>
References: <18748.62215.331271.141163@gargle.gargle.HOWL>
	 <20081208131440.GA7365@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-d4ibdIlbKgiwHOaGG+Ou"
Date: Mon, 08 Dec 2008 14:19:09 +0100
Message-Id: <1228742349.22164.82.camel@johannes.berg> (sfid-20081208_141917_670383_BF93C582)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-d4ibdIlbKgiwHOaGG+Ou
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-08 at 15:14 +0200, Jouni Malinen wrote:
> On Mon, Dec 08, 2008 at 03:42:23PM +0530, Sujith wrote:
>=20
> > HT management is done differently for AP and STA modes, unify
> > to just the ->config() callback since HT is fundamentally a
> > PHY property and cannot be per-BSS.
> >=20
> > Add a new NL80211 attribute to enable/disable HT (NL80211_ATTR_WIPHY_HT=
).
> > NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET now has only the secondary channel
> > offsets.
>=20
> Looks reasonable to me. Please just make sure this gets in before
> NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET additions get included in any
> official kernel release since otherwise this would change the userspace
> API..

I don't like it because it allows specifying "disabled/_above" and a
bunch of other invalid combinations.

johannes

--=-d4ibdIlbKgiwHOaGG+Ou
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPR7JAAoJEKVg1VMiehFYD7wQAJFpwl7LLRSBKawA3SGWzT9r
yweP590SJom3itH1Xnb+929EuhzOQL71s5RfF4HblyHmPYdx5XG6w7yacagX9IqX
uUdOuljFH/sGC1346cBYaLEafK7PCPzVvwVrhwfj1kZaT9lYZDAnNnlhhlPBDSCs
yiF2bfTWVCni1xFJxO9cYQ446jDnQOaFKbnlGiIb28bJ060Xoz3z3KsNpLjjgMBN
9HE0xcehccsEJMG3v+qfUF5nxhPXNG5B9JHf44UfgiA+lh31JQzDDn1af2ZfDRYF
TpsMVOAG0tJmZS1kRON2xO5pAWjSdCEtnw6pUMZipn7ExFU2mUvKy+8uBSdT//C3
7d1+B3vgNwf+oxq3sl3h8bQqEnQDukOUkT9GVI9uD6Z+6hEAf10vuHYlvePogxiG
r0RzXFAh5YVIkXCaXEpAyXcV2tCJftnhE6viwATMT9bEri1uXal8F8hTe1OnFUUW
8JM4z1iL/kMOhthboFz4oszuxNl9AeNvAsw0H/LcB8I8w+mDjAAybQ/tbqKW06f8
ev8YpWRLijCTFdXHOj+LUqeNWEhhfKuUjFP4n4KmNeOsHbnd/5UHkXuCJ58YbsA8
WkmLcUbFyHWUTvQb95P0xXG9/tXKk6waXL5pHm4job8abAgA/ONRVuzrKDr6Lx5Q
E5knMgsrVY+8jY2/tIvg
=lLZY
-----END PGP SIGNATURE-----

--=-d4ibdIlbKgiwHOaGG+Ou--

