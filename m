Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58033 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZGRSWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 14:22:21 -0400
Subject: Re: [PATCH] rfkill: remove too-strict __must_check
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A621264.4030102@tuffmail.co.uk>
References: <4A61EE43.4060003@tuffmail.co.uk>
	 <1247938802.18391.0.camel@johannes.local> <4A621264.4030102@tuffmail.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pr04lBxEeHOpVDQ03nNJ"
Date: Sat, 18 Jul 2009 20:22:18 +0200
Message-Id: <1247941338.4204.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pr04lBxEeHOpVDQ03nNJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-18 at 19:20 +0100, Alan Jenkins wrote:
> Some drivers don't need the return value of rfkill_set_hw_state(),
> so it should not be marked as __must_check.
>=20
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks.

> ---
>  include/linux/rfkill.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index f3d5812..1020290 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -238,7 +238,7 @@ void rfkill_destroy(struct rfkill *rfkill);
>   * should be blocked) so that drivers need not keep track of the soft
>   * block state -- which they might not be able to.
>   */
> -bool __must_check rfkill_set_hw_state(struct rfkill *rfkill, bool blocke=
d);
> +bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
> =20
>  /**
>   * rfkill_set_sw_state - Set the internal rfkill software block state

--=-pr04lBxEeHOpVDQ03nNJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKYhLVAAoJEODzc/N7+QmafUwQAJScYzSGowtCJfcelWT2V16R
qNQCN/J5cS5dBty0n0AEGsjK1QhU5EH7rk2/b36naWqZijlzt0aYYGPeIvRTemUO
0Pjs678zYJIMLqWV3+yoOgZQ0F8ySYdPZTtCH2BfwDI/t2d+5XJhoNkpepQfnNJu
e5w4fHMMMfUfH6+H1ISCIjbYMc1ecKEiqQtfp1AUkK30oXsoFPlfbRbdw1Lmp5Iu
fY87IHyvdRiI5GfGpBSeTCYpaRttBy+pldAZ8EB9TmIaew0AWARTBy30DvV22cFj
C4g02i8HnwLYHiq0KWJNua+JVvOV3ZSsDCeQUSAj5709yU2bNh72j0Zq1FSdjqaX
+LDjzTSgJ+ZJzBU3ghmRcQ2Zg1s/PhPQj37W0CezNpOnknRKwThhi6o32IVxkOtP
q8Z2MD4vfkhjH6SK5jSb1Tc9Ur0qans1TYcG+JOMXD/5DItrBcNCVW4XfL8H7Bb+
zYK/AvQ/VedxNiN9Etim/hCoaaqrCdpWwxTx/l1XRUx0Yy0SoKmqcfXWIDCBpPRS
3r+atSeZ22v9hhKgQc9zi/Xs+aaroszPunG4YBDHOyUioy+AvNTaJJj1+pRNxX+o
cNCppBWuDoQT9ZZoIZPzfjS4bIXYWOFZ1KoFL4/BG2Moa1ubxpvFTeBZgWUn6Kqc
l1dgtlHR8/tZUNGUmp/R
=xw7p
-----END PGP SIGNATURE-----

--=-pr04lBxEeHOpVDQ03nNJ--

