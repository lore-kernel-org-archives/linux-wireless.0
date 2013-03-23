Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:58854 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab3CWSUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 14:20:44 -0400
Received: by mail-ea0-f172.google.com with SMTP id z7so102317eaf.31
        for <linux-wireless@vger.kernel.org>; Sat, 23 Mar 2013 11:20:43 -0700 (PDT)
From: ISE Development <isedev@gmail.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Reply-To: isedev@gmail.com
Cc: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>,
	Chris Vine <chris@cvine.freeserve.co.uk>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: A fix for DMA transmission sequence errors
Date: Sat, 23 Mar 2013 19:20:26 +0100
Message-ID: <3155250.mfr6joo93v@wks001.ise.net> (sfid-20130323_192100_778342_43184F59)
In-Reply-To: <CACna6rze+5YaU3Ec2iEnP7G_gT-bYVwSiefSSFioK4E9dYZxoQ@mail.gmail.com>
References: <514a07c7.ZQz6MhmMaq58WJlA%Larry.Finger@lwfinger.net> <20130323184357.6b4f2037@milhouse> <CACna6rze+5YaU3Ec2iEnP7G_gT-bYVwSiefSSFioK4E9dYZxoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart9284329.sm8SDJ5AUE"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart9284329.sm8SDJ5AUE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Saturday 23 Mar 2013 19:01:26 Rafa=C5=82 Mi=C5=82ecki wrote:
> 2013/3/23 Michael B=C3=BCsch <m@bues.ch>:
> > On Sat, 23 Mar 2013 18:28:33 +0100
> >=20
> > Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
> >> > Could you try changing
> >> > B43_DMA32_RINGMEMSIZE
> >> > from 4096 to 8192 in dma.h?
> >>=20
> >> Blah, ignore that. You're card has 64b DMA, not 32b :|
> >=20
> > You could try playing with the constants anyway. Maybe something
> > interesting happens.
>=20
> Won't hurt.
>=20
> Chris, isedev: can you try replacing B43_DMA64_RINGMEMSIZE with some
> higher values than 8192?
>=20
> 8192 is 0x2000, so please try 0x4000 or even 0x8000

Tried 16384 and 32768. No difference observed (same sequence of errors)=
.

--
-- isedev
--nextPart9284329.sm8SDJ5AUE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJRTfJzAAoJEJyauGFL3QqoanoH/2KCsb4KiW33Tku7hyDCJhy9
JwRwhjFehwbEKIKaUHSPhFCl8nQGxVs63BERykmHp4/U9D4O+cRgwO/ALjCV5ghQ
GLODzvwQvJkCOMXhXCyExPVDn1RqSf4OI3dHdXJPTvVbh9tOmn26Vosw07Tmre+p
gKK7sdvxgM5JGYPG2Alue949DD57qxJfG2VH9oZU0aAnGLxGtl8f8F9sxJFxLyo1
f1QDPZOgzQkqapbri5xWnARo3op/SYua/HFPLLZE7KC4qJO/x8bSdI6mYgHt1YyC
9PjCnJkoxHlqc4iosviLaa+6ESrAs7yOApfh6FH6ZUI56I4NgORDRtvwO7a7Dgk=
=aqI/
-----END PGP SIGNATURE-----

--nextPart9284329.sm8SDJ5AUE--

