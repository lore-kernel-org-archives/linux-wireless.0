Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46412 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281AbaCPSZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Mar 2014 14:25:43 -0400
Message-ID: <1394994345.15764.96.camel@deadeye.wl.decadent.org.uk> (sfid-20140316_192546_661716_3968C75F)
Subject: Re: [PATCH 3/3] ath10k: add firmware files
From: Ben Hutchings <ben@decadent.org.uk>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, dwmw2@infradead.org,
	ath10k@lists.infradead.org
Date: Sun, 16 Mar 2014 18:25:45 +0000
In-Reply-To: <87wqfx8856.fsf@kamboji.qca.qualcomm.com>
References: <20140314084501.23100.13103.stgit@x230>
	 <20140314084514.23100.72654.stgit@x230>
	 <87wqfx8856.fsf@kamboji.qca.qualcomm.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-gD6QHAYxaeLJSqe81JyY"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gD6QHAYxaeLJSqe81JyY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-03-14 at 11:03 +0200, Kalle Valo wrote:
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>=20
> > Add firmware files for ath10k wireless driver with the new QCA license.
> >
> > Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> > ---
> >  LICENCE.qca                         |   44 +++++++++++++++++++++++++++=
++++++++
> >  WHENCE                              |    9 +++++++
> >  ath10k/QCA988X/hw2.0/board.bin      |  Bin
> >  ath10k/QCA988X/hw2.0/firmware-2.bin |  Bin
> >  4 files changed, 53 insertions(+)
>=20
> I forgot to mention in the commit log that the version of this firmware
> is 10.1.467.2-1.

Please put this in a Version field to the WHENCE file under each File
field.

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-gD6QHAYxaeLJSqe81JyY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUyXsqee/yOyVhhEJAQrEnBAAzJxWHh3O1N4Wa8JEFs51p4T+29wnJNFa
xLn5Y0xpplFWJqKId0EoDd/YQtSdlDTPCJ0DukGbNhxJRf/vBQBYuVF+UGePdWWK
1hizTWjMg1qrro5975yBv3/Z+f2w8Rc817oh3fdIEnQrR53qLX0UnHwi89xCn0jQ
xVxxiiDwBsohnZpPUonOaWhDpb3K1Lo1R4nF8nnQqKaKi5bPNUc1zr0J/ZdNWueC
oyrPz+8da0uwhKOg9tCLwVMp6KP1lWEjLWUcR1EOEDbe0mE0CUqsSbkz/VBABeOX
bxJTpPYAdXqh7Z111vpAWpniAHi9+8uib19KYLmbun+TLDd7DeHb9vJ7afRwQA10
xxHo7bhg6HhvfSVO6EchaemAhEfGT2C/ZPG0OKnkNZmbjqk6ywj2NGxCz8ppGlYk
X1HMK/NEJ4WWN5nGa3Xdqaoa27VLTZxF6pM1rKbJSpzpniHd49uglIVIaiCuVHCo
9tBhUYUkRCHJ5nsobWlMr9Wu6y8BfHzRYZyC2kXvQmzMguPJpU5aEHPf1NZyxh9/
pQa+VUYus68YrbvTvKzamrSxX+ksSApZ5bWnaz+UWicMUvYWRvQLR8zYzTh9Hmcy
IZonX5MKHcTIMQCt90Z2xMaUNc5CZFJG6kmgEqiABHF2oHtA6OOljLRS4QLiSJOm
LzCdul6yxDg=
=R8su
-----END PGP SIGNATURE-----

--=-gD6QHAYxaeLJSqe81JyY--
