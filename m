Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629AbXBSUzd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 15:55:33 -0500
Subject: Re: [PATCH 03/10] introduce wiphy concept
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20070219213716.183719c9@griffin.suse.cz>
References: <20070215144241.847938000@sipsolutions.net>
	 <20070215144257.530315000@sipsolutions.net>
	 <20070219213716.183719c9@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-trdZTRgnpqs5ppv30nwX"
Date: Mon, 19 Feb 2007 21:55:17 +0100
Message-Id: <1171918517.15489.12.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-trdZTRgnpqs5ppv30nwX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-19 at 21:37 +0100, Jiri Benc wrote:

> Currently, you need to distinguish whether some random net_device is
> wireless device or not at some places. At least d80211 needs that (yes,
> ifindex doesn't wrap often, so those are just safety checks, but - well
> - I'd like to be safe).
>=20
> How can this be effectively achieved if ieee80211_ptr is dropped?

Not easily at all. Just thoughts anyway :)

johannes

--=-trdZTRgnpqs5ppv30nwX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF2g61/ETPhpq3jKURAmJRAJ4z3oTlpaGeXeniSc292HmIWEio0wCfdzfs
z+H988nI0Twkl6BPk969I4Q=
=MsT5
-----END PGP SIGNATURE-----

--=-trdZTRgnpqs5ppv30nwX--

