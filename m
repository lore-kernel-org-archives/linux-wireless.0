Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbYEZTrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 15:47:10 -0400
Subject: Re: oops on b43 insertion on mips
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <483B105E.4090800@wpkg.org> (sfid-20080526_214449_728839_4A2255E3)
References: <483B105E.4090800@wpkg.org>
	 (sfid-20080526_214449_728839_4A2255E3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-odKtvnxZ3piyNyp4h9q9"
Date: Mon, 26 May 2008 21:46:00 +0200
Message-Id: <1211831160.3930.0.camel@johannes.berg> (sfid-20080526_214713_162357_19FC0BA3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-odKtvnxZ3piyNyp4h9q9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-26 at 21:32 +0200, Tomasz Chmielewski wrote:
> I just compiled 2.6.25.4 for BCM47XX (little endian MIPS).
>=20
> When I try to insert a b43 module, the kernel oopses. Are there any=20
> fixes for that?

> Trace:[<c00681c4>]

We'll need symbol info to answer your question.

johannes

--=-odKtvnxZ3piyNyp4h9q9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDsTd6Vg1VMiehFYAQL+vA//b0poPFjZXNIR7nZLujzcVlqpUrAyo/aF
rTZd4rb2vzlu9xwxgB0QMQuYcbIVHdFLG195vJRArUkzuyyRaSsnFyCyw6vrDy8Z
pU562rrT/rq++A12dd33wWIFt3psaoWLplNAMhHcR5du9vvZF+AJ6eq/tZ4GN/JB
bEYj4n6qK9brY2bRNkQZszUEVdaDju8XwuFycNx96s8HkVczETNCG0LQEyaIvdV4
HpJauXjuqsNvLgAkbJKF+J47mh3UW65jYRv53DwrErJ2KtmV9MFvglcMXy9y69vD
viigxNOnstj6kMgBMVcSZWk2oKPiNGOcQqLHiV/AnhI4BWx7Gqu/pXsfxyxlhSGM
HA+QhEVK9qjOpzzEDGWe4Jlin8I3G6IHO4UnZyrCS8oiCqqOBI5DYeyH7StLOchj
u2VHfz3no5WuBllwBPnqubdzvV1VoUgW2o/ync/dYpGNfpxuQbUqlExAE5+9PB7e
KF96ZlB98RHCAjU/S3FFFhlyZBNSdIPW7cRB6EepzRVV+naN7e5AnwLthy9O5ZB/
jE+K+AM/D/hWhIFANhZqCvlllCuxRYweQJmN7WrspNJEea/5+jBoFkggMqFdfaXe
5hLIFfYrww6bhxeuwJ1IyhBnmjWy22ny3vQuErW5eXx7hySc3QoAVWRgAsjHsh0P
Fm1IrEjWP/Y=
=yrGn
-----END PGP SIGNATURE-----

--=-odKtvnxZ3piyNyp4h9q9--

