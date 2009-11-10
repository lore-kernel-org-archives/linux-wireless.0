Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbZKJJOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 04:14:51 -0500
Subject: Re: erraneous connect with short-slot-time fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <m3d43qu7v1.wl%holgerschurig@gmail.com>
References: <m3zl6wq8x7.wl%holgerschurig@gmail.com>
	 <m3d43qu7v1.wl%holgerschurig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bT1DLKF0uAAlbYDUUPAe"
Date: Tue, 10 Nov 2009 10:14:24 +0100
Message-ID: <1257844464.3623.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bT1DLKF0uAAlbYDUUPAe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-10 at 09:00 +0100, Holger Schurig wrote:
> Side node:
>=20
> > wlan0 (phy #4): auth 00:1b:d4:44:35:90 -> 00:15:e9:84:1a:54 status: 0: =
Successful
> > wlan0 (phy #4): assoc 00:1b:d4:44:35:90 -> 00:15:e9:84:1a:54 status: 25=
: Association request rejected due to requesting station not supporting the=
 short slot time option
> > wlan0 (phy #4): failed to connect to 00:1b:d4:44:35:90, status: 25: Ass=
ociation request rejected due to requesting station not supporting the shor=
t slot time option
>=20
> in this case, I had a case where the AP did send an authorization
> response with success status, but an association response with an
> error condition.
>=20
> You once asked if I tested that.
>=20
> Now I did, and it looked like mac80211+wpa_supplicant did the right
> thing in this case.

Heh yeah, but we fixed that in the meantime :)

johannes

--=-bT1DLKF0uAAlbYDUUPAe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+S7sAAoJEODzc/N7+QmaEi0QANAklGcabPI48hXnDBUHdICj
nZKzvjCz/f8MhPauzlbjff2h/X8ALUXg4rFAb5WYzoxsSzZrrTm3/VkwmPnrFZqO
AvK2d+VCEdN9HRYTtNEHJGpVBjej58Aq1OZ26wdvcsT3B3dXN7wuT0OVeTKmHhMp
bJZb/lh1JObGTs22Mk8M+QEbpT5IiVc3pyaYXMbloSw1NNN1zDM8JtbNT92ZueV9
Y9G0glplyx6XPIjgWzW8j6I5WzTDkN5UcTD9tDRvo+wwzAJKcmlquVKuSwpaZj9i
5yNTR6SM/hlu012bK2Z4DVCoVM9TYJTzSAxyxh3L2fUdTfPNmzC5pzb5ggCimJ1F
i1aBUdMM0YGKgneZkIG4cmPO+nBm7B4r2IzdcVZJnRjVhjeSy5N/Ktg6w9alX1GG
SvQeZa49Kx0rvzTBVfIo4l+AXgzoUF6XLuvPpu8WAeBT3obwj873qn9EGxoDPqnj
7DogEEy1wTLf8l+8wFw9YQx1hQ9k3Q7UPjKEnhWHAEKeH+H0JXsBr1cO89ucEYf7
+hgiC05yZGnYQqAJYeE+rN9Fh7XZaX5HVhlyk0n3MM9DAwQWTKj2T0NoVJtSU57i
OtXFeNmTxRO9fx15MYh7l/au80+JY/+bp183/4Cw/72IL7YVMGjl741+OJgBUG8j
Xg8C/Tnt90B/U+l+b66E
=Rjn3
-----END PGP SIGNATURE-----

--=-bT1DLKF0uAAlbYDUUPAe--

