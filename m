Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:48245 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755032AbYDMKUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2008 06:20:42 -0400
Received: from ironport-out-2.rz.rwth-aachen.de ([134.130.3.59])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JZ900LPME1PFY60@mta-2.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Sun, 13 Apr 2008 12:20:13 +0200 (CEST)
Date: Sun, 13 Apr 2008 12:20:11 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
In-reply-to: <1208081495.4111.32.camel@johannes.berg>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Vladimir Koutny <vlado@ksp.sk>
Message-id: <4801DE5B.9090903@archlinux.org> (sfid-20080413_112048_128235_277C1A35)
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enigB48404172F76FC9795D4875F
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
 <200804021932.26046.IvDoorn@gmail.com> <47FE8FAD.9020802@archlinux.org>
 <200804121246.44236.IvDoorn@gmail.com> <4800F76C.7000801@archlinux.org>
 <1208072495.4111.10.camel@johannes.berg>
 <1208074049.4111.18.camel@johannes.berg> <4801C4FF.5060606@archlinux.org>
 <1208081495.4111.32.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB48404172F76FC9795D4875F
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Johannes Berg schrieb:
> Even using use_short_preamble wrongly shouldn't give much of a drop in
> network speed. I fear there's another bug. Is your AP even
> short-preamble capable? Maybe that's the problem, your AP isn't
> announcing short preamble but we're enabling it by that code? I haven't=

> looked in too much detail yet though.

It's a WRT54GL, so I suppose it supports it. On my laptop (iwl3945), I ge=
t
wlan0: switched to short barker preamble (BSSID=3D00:1d:7e:43:14:a7)
after connecting to the wireless and everything is still okay and fast.


--------------enigB48404172F76FC9795D4875F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkgB3lwACgkQEda5KzHP/VCh1wCgvEN8OCaAv3VUG60QZvzNIwjl
KHwAmwUJB1090jr2SGuBiYuYhQwCPI2Y
=MiNj
-----END PGP SIGNATURE-----

--------------enigB48404172F76FC9795D4875F--
