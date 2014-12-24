Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:63388 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaLXQqi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 11:46:38 -0500
Message-ID: <549AEDDA.3050507@rempel-privat.de> (sfid-20141224_174641_393616_C598EAFB)
Date: Wed, 24 Dec 2014 17:46:18 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Melroy van den Berg <webmaster1989@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] IBSS network crashes after one device leaves network
References: <C7367401563A9D46BC5A92B9456C061D48D210@G08CNEXMBPEKD03.g08.fujitsu.local>	 <54455DDF.50305@rempel-privat.de> (sfid-20141020_211003_234775_62CEB57E) <1413833356.32358.4.camel@jlt4.sipsolutions.net> <5446660B.4040602@rempel-privat.de> <loom.20141224T034313-122@post.gmane.org>
In-Reply-To: <loom.20141224T034313-122@post.gmane.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hkQ1mNAFd1DojHiKmq6vgP2pO1ivi6HgA"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hkQ1mNAFd1DojHiKmq6vgP2pO1ivi6HgA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 24.12.2014 um 03:45 schrieb Melroy van den Berg:
> Oleksij Rempel <linux@...> writes:
>> hmm.. suddenly rate scaling is not singe limitation of ath9k-htc.
>> Firmware keeps some information for each STA and trying to reduce usb
>> bandwidth. If i understand it correctly, ath10k works in the same way.=

>> It means, early or soon we need to work with some hard limits.
>=20
>=20
> I think it's exactly the same limit as for the AP mode.
>=20
> See: https://lists.ath9k.org/pipermail/ath9k-devel/2013-April/010513.ht=
ml
>=20
> There should be some solution, atleast the IBSS network shouldn't crash=
=2E

Yes,
right now i have no time to work on this problem. To anyone who can, you
are really welcome.

Here is a script to crash at leas one pear from adhoc network:
http://pastebin.com/KhXgQ15V
--=20
Regards,
Oleksij


--hkQ1mNAFd1DojHiKmq6vgP2pO1ivi6HgA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlSa7d8ACgkQHwImuRkmbWknYwEAk9CG4D2IQb9CPm5811j/cuIB
nV/w32917c7wkSabW3YA/jmZxWdcPU/gUTR6nryYiAXOZ9vQ5S1TiZpBJ8RQwP5D
=ZrHU
-----END PGP SIGNATURE-----

--hkQ1mNAFd1DojHiKmq6vgP2pO1ivi6HgA--
