Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684AbZGNWhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 18:37:36 -0400
Subject: Re: unable to bring up iwlagn wireless after update from 2.6.29.6
 to 2.6.31-rc3
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Backlund <tmb@mandriva.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4A5D0374.5040702@mandriva.org>
References: <4A5D0374.5040702@mandriva.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zdYPj3whRoWXrMSDf0Ks"
Date: Wed, 15 Jul 2009 00:37:04 +0200
Message-Id: <1247611024.1796.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zdYPj3whRoWXrMSDf0Ks
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-15 at 01:15 +0300, Thomas Backlund wrote:
> Hi,
> (please cc me on replies)
>=20
> before I start to try and figure this out, I thought of asking here if=20
> it rings any bells...
>=20
> Distribution: Mandriva Cooker
> Arch: x86_64.
>=20
> NIC: 04:00.0 Network controller [0280]: Intel Corporation PRO/Wireless=20
> 4965 AG or AGN [Kedron] Network Connection [8086:4229] (rev 61)
>=20
> ucode version: 228.61.2.24
>=20
> wpa_supplicant version: 0.6.9
> crda version: 1.1.0
> wireless-regdb version: 2009.04.17
>=20
> Running a 2.6.29.6 based kernel works with iwlagn
> Running a 2.6.30.1 based kernel works with iwlagn
>=20
> Running a 2.6.31-rc3 based kernel gets me this:
>=20
> --- cut ---
> Bringing up interface wlan0:  RTNETLINK answers: Unknown error 132
> RTNETLINK answers: Unknown error 132

press your rfkill button.

johannes

--=-zdYPj3whRoWXrMSDf0Ks
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXQiNAAoJEODzc/N7+QmaOQYP+wYhvyk/4Cxa5imuWUsHuaQ/
bdSGiLCAnSlY6Rh+B3w/BKSs1oJ2eGH+Im4AoYaLrbrWCepqcgILfzQmmfMoqokO
KLSX1CXI3Hwu2GZPDXQ8mBjGhyehqVflOm9GPp9ifmao0CmmwDd4f8S9pgD2s0Fo
VoQ866X+a6UHFybkzrv67Bu4c1CCHZ3KGD6sTQyhjf3rVrDZwWYuwDSTX3ENPz4m
FzYy8BYta0b7V85gVKBX4d8JBj8rkNJJywgZoyZrw/ssIgD1nI6NRiyYOGXtcgBC
IW3nBkFDjCC4iw6eYP60DsUbdHU7JCb5V67FJpf9oBslQrfW8xEzFCWWhEfLBSj1
TQu7P3ExZsHuRnGQhIPugpny1/514LMR9bWtwTA3L45usKQaCCF3a139bvRnVBEP
QJvV5fmb7SsLQJpnZyOOa+JaBu/JCGqBAGSuAGWz/HR6Mwff6d8Qz26iJN85EgiE
eazhzIK7Bzw657V224i8EkwJNI+v2WZqvf4dof0EO9WYpLg5S5S5qADdxNbwe83h
M6M31tDAINXzPgZ00uhKcVG8YjH2ZKDRFnwvKxczpJMFLNKx/5DEOceISQMw0lGy
ecfK0jH6PmJHPCQ8kVcce36u5Hd31CbbmvAkJHG+HSnTEbjRD19fc5ecdIb4oupy
XBpulUU8DGaVszyWYwHG
=fuoL
-----END PGP SIGNATURE-----

--=-zdYPj3whRoWXrMSDf0Ks--

