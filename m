Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34509 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbXHRJDb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 05:03:31 -0400
Subject: Re: [PATCH 14/20] mac80211: kill key_mgmt variable, use  privacy_enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070818035909.GE1415@jm.kir.nu>
References: <20070815144920.135826000@sipsolutions.net>
	 <20070815145047.834125000@sipsolutions.net>
	 <20070818035909.GE1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/uggDcNb8Y3dUdGhlqw5"
Date: Sat, 18 Aug 2007 11:03:29 +0200
Message-Id: <1187427810.6090.31.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/uggDcNb8Y3dUdGhlqw5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 20:59 -0700, Jouni Malinen wrote:

> This looks a bit odd, though, taken into account that this is coming
> from IW_AUTH_KEY_MGMT and not IW_AUTH_PRIVACY_INVOKED.. It would
> probably be better to just remove all the crab from here can ignore the
> IW_AUTH_KEY_MGMT value in mac80211. The only place that actually used it
> in the client code (mixed cell configuration) had already been broken,
> so this could all be just removed completely unless someone has plans on
> fixing privacy mismatch detection.

Yeah, it should probably be called "key_management_enabled". However,
privacy mismatch detection does work for WPA, just not for Volker with
dynamic WEP for some reason.

johannes

--=-/uggDcNb8Y3dUdGhlqw5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxrXh/ETPhpq3jKURAmEzAKCZKt/+a9rYcIcEkDFq7J7QNb5pAACgqH1E
ouoIR6HqW4aLBqFTuEDQC8I=
=PZmd
-----END PGP SIGNATURE-----

--=-/uggDcNb8Y3dUdGhlqw5--

