Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:60481 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758279AbZLIW7a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 17:59:30 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NIVVP-000082-2U
	for linux-wireless@vger.kernel.org; Wed, 09 Dec 2009 23:59:35 +0100
Received: from 85-127-91-132.dynamic.xdsl-line.inode.at ([85.127.91.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 23:59:35 +0100
Received: from tim by 85-127-91-132.dynamic.xdsl-line.inode.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 23:59:35 +0100
To: linux-wireless@vger.kernel.org
From: Tim Blechmann <tim@klingt.org>
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
   in 2.6.32
Date: Wed, 09 Dec 2009 23:59:10 +0100
Message-ID: <hfpa3v$5gj$1@ger.gmane.org>
References: <20091204233202.GA13658@basil.fritz.box> <4B1BB44E.90706@gmail.com> <4B1CCB81.5060104@klingt.org> <4B1D7A6B.1080606@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5DE5F7EBA443B4FAF43E24EA"
In-Reply-To: <4B1D7A6B.1080606@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5DE5F7EBA443B4FAF43E24EA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

> I can't reproduce any boot failures with the patch applied, although fo=
r me the rt2x00
> drivers are compiled as modules. Can you provide some more information =
on the boot failure
> that you see?

i am pretty sure, that i am experiencing the same issue as described
here [1] with stack trace ...

[1] http://lkml.org/lkml/2009/12/8/207

--=20
tim@klingt.org
http://tim.klingt.org

art is short - life is long
  Jack Kerouac


--------------enig5DE5F7EBA443B4FAF43E24EA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksgK74ACgkQdL+4qsZfVsuPfwCfTMS+3uXcyWCgQtPeqsmhQNwr
oDIAoJhxcNqHvxqbSU4sxgJ88WyL4MaI
=brBp
-----END PGP SIGNATURE-----

--------------enig5DE5F7EBA443B4FAF43E24EA--

