Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46199 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbYDZPzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 11:55:39 -0400
Subject: Re: rt61pci current wireless testing git gives kernel oops
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Bas Hulsken <bhulsken@hotmail.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200804252031.56605.IvDoorn@gmail.com> (sfid-20080425_203116_969250_F59BCB3A)
References: <1209147056.2955.7.camel@Bas>
	 <200804252031.56605.IvDoorn@gmail.com>
	 (sfid-20080425_203116_969250_F59BCB3A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gHIRiU51cZcYQKhQdtcz"
Date: Sat, 26 Apr 2008 17:55:31 +0200
Message-Id: <1209225331.10943.26.camel@johannes.berg> (sfid-20080426_175556_830781_64E0684B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gHIRiU51cZcYQKhQdtcz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> > the interface goes up well, but I get an oops as soon as I run hostapd,
> > seems something with debugfs. This shows up in dmesg, let me know if yo=
u
> > need any more info.
>=20
> Johannes, this issue might have been introduced in your patch
> "[PATCH] mac80211: fix key vs. sta locking problems"
> do you know about this issue?

Huh. I'll take a look but I've run hostapd before w/o problems. I might
not have had encryption enabled though, don't remember.

johannes

--=-gHIRiU51cZcYQKhQdtcz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBNQcqVg1VMiehFYAQLPmRAAqSp0GJwo2UnZa856EFpJgQ2e5cK6p+iB
mxpOjvZeMRgQBwywezuHEWYwZsYIhH7A7Y6+aXp+X/OkNrn0oxJW2Gj7H/q/2FXe
00l4U0ti1ic6yMMSZfezNnbbxkrikCpmJUtYgMg5kf0A4pM609fl6vhIFIbUr8mg
QguJ6Z1Zz4eBwjMpMAe+2ywmIPzxXqlkl3NHTOC3xd/bcVpF1R9tjmSieQteyE3h
OD/WA5X5wryyEWuhYrwkpRZrLfh9EWgdzl8zUCF+MY7ws4uPyVstHwsQOnsB5hDJ
WnWBvGopNADixJ259PZXCMPoxm3XR4CNNgAN6lJ4iRyTejlQ5ViBVnOuyleZzqm1
hAGYZJ4pcp4tw4tSMjaI3E8TbY0miWA1SvY40W9hu10BoYtUn2kopEP9GGmWo1vb
xNGbGLdDBQv7V++XdrW1ugQwAw4MyyT/WYBo0A0zq7JS/gQP9fJmU4c4Ica6tjyZ
3EbDPXEvDOv/u7H5ojUeyukyWs48NgrOFPa6NbmeLdB1AWDbTFeQ6fWJ2mGKAgU/
nPDI+TUgt1jildLogrS9j5zZDnYoCTG86U66z5YWj39ZyY6rknl0a6VxEE7ES+HI
W+lorTzwWCt0fWqHtUlKlVZAopm87CJCPRRO0mmRkT5WkuBFN4s7RB16t3PVtMQ6
9gE7tN+HDuE=
=2D2U
-----END PGP SIGNATURE-----

--=-gHIRiU51cZcYQKhQdtcz--

