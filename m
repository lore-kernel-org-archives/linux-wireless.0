Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx38.mail.ru ([194.67.23.16]:50105 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYKTRx5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 12:53:57 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Kamil Dzida" <kamil.dzida@gmail.com>
Subject: Re: Symbol orinoco firmware under BSD, no extracting tools needed
Date: Thu, 20 Nov 2008 20:53:44 +0300
Cc: linux-wireless@vger.kernel.org
References: <7fe9ff8d0811200345o5c2a219dk256483a55c3b9e6a@mail.gmail.com>
In-Reply-To: <7fe9ff8d0811200345o5c2a219dk256483a55c3b9e6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1373366.1vkrImgdj2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200811202053.52132.arvidjaar@mail.ru> (sfid-20081120_185400_366437_EF096A0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1373366.1vkrImgdj2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 20 November 2008, Kamil Dzida wrote:
> Hello, for some time I have been interested in situation of firmware
> for Linux drivers. I found something interesting.
>=20
> Some time ago I found that Agree firmware for orinoco driver was
> submitted to linux-firmware tree. From driver documentation
> (http://www.linuxwireless.org/en/users/Drivers/orinoco) I found that
> orinoco driver also works with Symbol "Spectrum24" chipset. The
> documentation states that firmware for that chipset is only available
> by cutting it from Windows or Apple drivers (like Broadcom microcode).
> Fortunately I found that it is not true. The firmware binary blobs for
> Spectrum24 can be found on NetBSD and OpenBSD servers under BSD
> license. Both have build in this firmware in their operating systems.
>=20

Does it support WPA and/or WPA2? Have you tested this firmware with
orinoco driver?

Thank you!


>=20
> This statement can be found in OpenBSD CVS:
>=20
> from netbsd:
> Generated from the firmware binaries for T3 series CF adapter.
> Obtained from Tim Gardner <timg@tpi.com> who developed the Linux driver.
> And approved by Brad Lefore <blefore@sj.symbol.com> to redistribute it
> with BSD license.
>=20
> (http://www.openbsd.org/cgi-bin/cvsweb/src/sys/dev/microcode/symbol/esecs=
ym?sortby=3Drev)
>=20
> This means that the only difference between firmware that Linux uses
> and the *BSD firmware is that BSD people successfully negotiated
> license change to BSD. Theoretically by simple drag and dropping the
> files from OpenBSD/NetBSD to linux-firmware tree and renaming the
> files will allow Linux users out of the box support of Symbol cards
> without any firmware extraction tools. Just in case, contacting Mr.
> Lefore of Symbol first would be also recommended.
>=20
> I hope this information will be helpful for orinoco driver development.
>=20
>=20
> OpenBSD resources:
> http://www.openbsd.org/cgi-bin/cvsweb/src/sys/dev/microcode/symbol/?sortb=
y=3Drev#dirlist
>=20
> and licence:
>=20
> http://www.openbsd.org/cgi-bin/cvsweb/src/sys/dev/microcode/symbol/symbol=
=2Dlicense?rev=3D1.4;content-type=3Dtext%2Fplain;sortby=3Drev
>=20
> NetBSD resources:
> http://cvsweb.netbsd.org/bsdweb.cgi/src/sys/dev/microcode/wi/?only_with_t=
ag=3DMAIN
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20



--nextPart1373366.1vkrImgdj2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkklpCoACgkQR6LMutpd94zlwgCfZAtYVQxZB7ELzoKUYGWr5gGn
yp4AoKVXWmiwPB23Yf4MIdDoGBfpDOtE
=OMt4
-----END PGP SIGNATURE-----

--nextPart1373366.1vkrImgdj2--
