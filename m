Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47163 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754620Ab1EME6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 00:58:45 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Walter Goldens <goldenstranger@yahoo.com>, 596626@bugs.debian.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, maximilian attems <max@stro.at>,
	linux-wireless@vger.kernel.org,
	Geoff Simmons <gsimmons@gsimmons.org>
In-Reply-To: <13602.31426.qm@web161615.mail.bf1.yahoo.com>
References: <13602.31426.qm@web161615.mail.bf1.yahoo.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-pGjoYFEfyT/5MdVSoIXW"
Date: Fri, 13 May 2011 05:58:35 +0100
Message-ID: <1305262715.4065.436.camel@localhost> (sfid-20110513_065850_737429_DCF0D25A)
Mime-Version: 1.0
Subject: Re: Bug#596626: [gsimmons@gsimmons.org: Bug#596626: Please support
 Linksys WUSB600N v2 WiFi USB stick]
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pGjoYFEfyT/5MdVSoIXW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-05-11 at 09:25 -0700, Walter Goldens wrote:
> > As mentioned by Jan, the device contains a RT3572
> > chipset.  Its entry
> > could moved into the section for known RT35XX devices (i.e.
> > "#ifdef
> > CONFIG_RT2800USB_RT35XX") as an alternative.
> >=20
> > Geoff
>=20
> This has already been done: http://git.kernel.org/?p=3Dlinux/kernel/git/i=
vd/rt2x00.git;a=3Dcommitdiff;h=3Dce2919c9fffe2aa52f9c3e327176d03764dbf9b5

That's all very well, but that isn't going to get into a stable release
for another 3 months!  Device ID updates that don't require new
supporting code should be sent upstream straight away (and cc'd to
stable@kernel.org).

I've cherry-picked this and the other two updates in rt2800usb that
aren't in Linus's tree, but that doesn't help the users of other
distributions that would benefit from them.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-pGjoYFEfyT/5MdVSoIXW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATcy6dee/yOyVhhEJAQoj0RAArlQqcADa6Ajprrvid2XlgLbwZzevGnpe
YRAl3dfezQHRBkjwSmAb3MkV1m7iiHLwsNkYO+SLVI3epx+bwMQw7UZA8TVHVngV
ikQyp/7OOd9vAhvPLZgH8E/LxHS4Kyu1F/QZBT1MmTk1IW0kRhmIvXlsYJmZzVVP
66ei/xRiH0qOgJnIS4Astq0kx5o3wKEqCDpfd/j1HU2M/624q6eyLaw7woAVNIXu
5UcAsHIDPQzHPqE9BMxN/eODhu/Y3h5gjVqwmeMaPxsPDEeudGcLwI+14fWdQGIX
tvV3adQRDgnngjjyh29ZblC2/U/HxS2NSVPxMfLVRlvTQPd4iBxSNPOGBoJkVnKW
GbCNwqIeJSqAEJemMQREfvM1k3UA5F6t1Upx2d87urdwfbQOPFEESPyOsP/rDleX
iw39IFK3y2CStry7zXmRvQKR6HRRm/lawz54y6iexr2ZhpksXDGuZAmOn0RO7XwV
is4XIGBqEtBY8FuzNevFISi9kUoin3asu6Pv2xQAVr0mpTqYw7OoqEZRAMHifphS
YCwXcb0TNpY91P8lWu1NnE4FtQChHS9dw+D9ZnJkUGKVNjxxuWeRdsuM5HdJO6En
ju5mlaxuDjmpk78nWR0dTeQrChsiVcjHukXo26mJDuXx+tiSfYJ/sq3xliHBFZBx
n3OjrgBOfuY=
=c6zq
-----END PGP SIGNATURE-----

--=-pGjoYFEfyT/5MdVSoIXW--
