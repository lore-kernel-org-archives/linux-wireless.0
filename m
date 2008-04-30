Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56205 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbYD3ORz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 10:17:55 -0400
Subject: Re: willing to work on a configfs interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxime COSTE <frrrwww@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <911e063c0804300129j4043e889i4fb670fcb10f4963@mail.gmail.com> (sfid-20080430_102900_497654_F2179A9B)
References: <911e063c0804300129j4043e889i4fb670fcb10f4963@mail.gmail.com>
	 (sfid-20080430_102900_497654_F2179A9B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DRuzSzTp0hutWF0kn+qE"
Date: Wed, 30 Apr 2008 16:17:45 +0200
Message-Id: <1209565065.18659.22.camel@johannes.berg> (sfid-20080430_161747_351014_0AA38E13)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DRuzSzTp0hutWF0kn+qE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Maxime,

> I'm willing to work on the linux kernel, and I thought that a configfs
> interface for the cfg80211 module would be great, I would like to know
> if someone is already working on that, and if there is any reason not
> to do it.

Well, the foremost reason not to do configfs it is that even nl80211
doesn't really offer much functionality yet. Is there any specific
reason why you want configfs rather than netlink? Would you want to work
on adding more cfg80211 API (especially for STA MLME)?

johannes

--=-DRuzSzTp0hutWF0kn+qE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBh/iKVg1VMiehFYAQIIaw//eUO/c/aYUgZNucgAyEHtu+X0mjvKRin1
h36Ct+5q8HJHHOlK1Di9zy0HGntSydBPDy3BVwybgq2Wnz7cF9PIDApvl9+ZCGdO
/fVAfqjwp6zO2s5VWmIuQRnx6QFjziShhyi36lO3gPXfyh5PN3t2pHIOmdeCVTzZ
16fVcviOLK71NzN0RnZxvItgnKlhd6z6hJwEythZ6vyVkuP+1NQeIapruwL9yM8G
+KtW5bbld/Qnytyd06Yjj4qmquV1dpP9Q/Slf+2/nP7my+fNrL568A+BDlcb0dkj
FtXdO9YiWPtHUQWpWMOA5Y8Vil2lHz7vJ002WGQQjZNXwIwaxhSEevS3PR1HrNMk
pm67K1W67F5B+GkBfWd9MAFPR72rvvFkfqu3vgmb7CP3hdqd9Vw4K7zdONU3oifq
5q3VJFJQnPNsNAEtNlo5jTPGfnTdri2/YEX1xwQCKrkI2qDn9XxJ5VeuDq7XM0rp
CbeNrIVpREeAzgPjMnzeWQwudJFNgP3V1xQ95atZGe0A6yB/ksAVFUIrLXxq5a2+
ZxEN1LjiqNLe2Xf6LWN5e7EZlmxQL2i8Ds92cMSB40M9P5Ywa2Q9bJNBvThZadhB
BrB2iBvo8hB2ypg08sAG89hF1QO8klRWSifJj1KPyBS9U61vYPrlcyOv2jtRKnqI
hySwq2JtfAE=
=ikJq
-----END PGP SIGNATURE-----

--=-DRuzSzTp0hutWF0kn+qE--

