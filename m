Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbZDYHmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 03:42:31 -0400
Subject: Re: [PATCH 1/2] ar9170: handle otus' A-MPDU density definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200904242135.57861.chunkeey@web.de> (sfid-20090424_213643_731367_9BD0F4EA)
References: <200904242135.57861.chunkeey@web.de>
	 (sfid-20090424_213643_731367_9BD0F4EA)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UESXQnN07urZXIZvQyhw"
Date: Sat, 25 Apr 2009 09:42:29 +0200
Message-Id: <1240645349.18031.52.camel@johannes.local> (sfid-20090425_094234_499743_0E98B525)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UESXQnN07urZXIZvQyhw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-24 at 21:35 +0200, Christian Lamparter wrote:
> Otus uses slightly different set of "Minimum MPDU Start Spacing" values
> than the 802.11n D2.0 specifies. (the whole table is shifted by one and
> therefore the 16us spacing is not officially available!)
>=20
> And while we're at it, we also initialize our MAC's density register.
> So, this annoying _feature_ will not break TX A-MPDU later.

Cute.

> +	.ampdu_factor	=3D 3,						\
> +	.ampdu_density	=3D 6,						\

FWIW, I also tried some varying values. This should indicate what you're
able to receive though, not what you're able to transmit since you
control that anyway. I think we currently don't have a setting though
for what to transmit with... this might need to be added somewhere
depending on the RA.

johannes

--=-UESXQnN07urZXIZvQyhw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ8r7jAAoJEKVg1VMiehFYD60P/jFzxlyDnLDQKHcoargaNhmV
KpRqXecsDO8nKotaBU8Vzia8CPeWIu/1SGQB31zoQhWatLS3Ou8bZxruo+CpFfeT
o0HeixWmBF282JO4EIvr1jb1fvUz8r6Tgd+FJaUpi/sZ+OAs7Tw2twxFS719eFeP
xmCXwk2t0IRwJo/Pwv3H5ubFesxMBLRkFMH2piWHVOgq/6ANyJptiqm0ON3KmrqW
eYO542NQMhymuBU2DpksZzfKS6hqmeqE2yUiszdZ3YfRUWcXV3lkdFfY3gesB7iD
R8i1evYbumBGYPWtC1WwDuAbuuH6BLk6KxJsZOEs47UKDZStFtq2KlgYgHU2lVCy
8wts8npGNDQHW5MV2hV0qAGKWyG0KV6HlDc6jnl+cIYfUn9hhRJkfUdApEyzIVWO
zB8S+1RILAoT3he5M1ofHcbNwYdO/w4VEfwDpDM9KTiekyrKkrEvcmrSjrbjXaPp
uzsji88avnKfS8saBPzgMdlIdFz5vNtQx/GEy7mUNMhlJ0dQXEfDiLDbxS44AZ+A
pOxK8q0ifTl+FK/8xGVK9bDuLiVDEMMjwLjRETQ/GnY8hSz4Iiw6GqtxGuJaUNUP
oNJVi2lwcl9w8budPncGUS97JqUd+56aVcV5dwHbt1UUtsr+yB5gwnrG8bi4QxLZ
MGb9QwS0Xy6VpgHw+HVs
=NDIB
-----END PGP SIGNATURE-----

--=-UESXQnN07urZXIZvQyhw--

