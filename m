Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:54710 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab3HPWS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:18:59 -0400
Message-ID: <520E7E63.7010606@blackshift.org> (sfid-20130817_001906_316316_8BD96680)
Date: Fri, 16 Aug 2013 21:32:51 +0200
From: Marc Kleine-Budde <mkl@blackshift.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k_htc: fix skb_under_panic error
References: <51ADBC01.6090202@blackshift.org> <1370371064-6903-1-git-send-email-linux@rempel-privat.de> <CAGXE3d9p7zkwfNJBJvPMc8XaKnb009pHpCXYweDjK4tv6PCkuA@mail.gmail.com>
In-Reply-To: <CAGXE3d9p7zkwfNJBJvPMc8XaKnb009pHpCXYweDjK4tv6PCkuA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ApjweFpcPsU4Egtxw9UhoCjkK7Be8WQIV"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ApjweFpcPsU4Egtxw9UhoCjkK7Be8WQIV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

On 06/05/2013 04:24 PM, Helmut Schaa wrote:
> On Tue, Jun 4, 2013 at 8:37 PM, Oleksij Rempel <linux@rempel-privat.de>=
 wrote:
>> This error seems to be really rare, and we do not know real couse of i=
t.
>> But, in any case, we should check size of head before reducing it.
>=20
> Mind to try the (completely untested) patch against wireless-testing in=
stead?
> Helmut

I'm running a kernel with a slightly modified version of that patch for
4 weeks without problems so far. I'll send a mail with that patch.

Marc


--ApjweFpcPsU4Egtxw9UhoCjkK7Be8WQIV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQIcBAEBAgAGBQJSDn5jAAoJECte4hHFiupUDFgQAIKzI579G6U1riLKYuBtLsB7
sDDuNkfdtjSagkd7yXpuEpt/59RCOYyfwjxLGSy/08EOOcsRdaFh97ZfyHa1hSBZ
+/KkF+ID1DiL47Adabzwrn01kdtXNKsF9LW4LDKFv8E4Euk3Ph9QkC+xeN87h2kg
SRJLDYgQWsbylNMXfVnMMtHe+TVqctX0FHTzyMQIAosfKHI7tfwsKuUe0KX4BBnv
4rHmY3QSj+WSZQhyWata+6bopQcPzt98j6K4g8dyqjxoc+WsB5+ui8JI/l6ahlEk
pQ4v6DyFbUZLXJvztWZ/L7kZfrjfeGKTpY9ThiyDOEUJP7fxFtsDOPx1tj8fY8vK
EUfjly/rHPStsfRtXNylBMb3CmvpmdL4j8/WBf3uJZ9Kam+tb6phy9BZ3ImLeUgj
bKix+0pxEnxRNEMm4DWifODsC/Xa2AXBU75MDtalWdU2M0Rm4osPdo03Y+d3a+CE
B9oIOZiNIQnr2AvCA4QRZrDpjHgFhudeg/3xP3C2OY5kBc11hMb9KxLQtMNmejwo
Tkayn5HX5zf3p2VtEjqC2VAoYAmearF+QQaxJqsuuMyLq45riSEDRYg1p64uMZkl
MHlVbscit1F8Cgdp868qX59xzygL2PBpVQnDbI/OC6enEYtSntq7wwgKUfWA6IZC
YU1hef2K/MfMFI5PVJJe
=LDm3
-----END PGP SIGNATURE-----

--ApjweFpcPsU4Egtxw9UhoCjkK7Be8WQIV--
