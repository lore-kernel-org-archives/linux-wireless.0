Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42343 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752600Ab2DPBvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 21:51:44 -0400
Message-ID: <1334541087.3209.39.camel@deadeye> (sfid-20120416_035149_355226_0D6CA4AD)
Subject: Re: [PATCH 0/2] linux-firmware: ath6k update 20120410
From: Ben Hutchings <ben@decadent.org.uk>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: dwmw2@infradead.org, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Mon, 16 Apr 2012 02:51:27 +0100
In-Reply-To: <20120410121708.15361.62740.stgit@x201>
References: <20120410121708.15361.62740.stgit@x201>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Sngji6coMPiDiyN2Hwg0"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Sngji6coMPiDiyN2Hwg0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-04-10 at 15:18 +0300, Kalle Valo wrote:
> (Resending as my --cc had a space and stgit didn't send this to the maili=
ng
> lists.)
>=20
> Hi Ben,
>=20
> here's a firmware update for ath6k. We update the AR6003 hw2.1.1 to the
> latest in our 3.2.0 branch and add a new firmware for AR6004.
>=20
> This is the first time I'm sending patches for linux-firmware so please
> let me know if there are any errors.

I've applied these.  However, in future please only add File: lines to
WHENCE for regular files.  I've now removed all such lines from the
listings for ath6kl.

Ben.

--=20
Ben Hutchings
This sentence contradicts itself - no actually it doesn't.

--=-Sngji6coMPiDiyN2Hwg0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT4t7H+e/yOyVhhEJAQp7EQ//SlJ6sKiUgzEBtk3q86VqcVJe9tCisW4D
7HM/z6OfjNr2aMN7oxOAusOtb4G7yLqgjfd8xmG6C/aSb8MsTZxuDNJyxUmxokGd
C8idWFqKuRdU+h3STlJrPMCzkWFjKMYlUNcQf1OCWYEWnn6S1KvN0HoEj/NTpXz4
Q/2+jt08ISE9eLcg9uGAIBvnrIw6+TPOa4QzsJILBk8w4inrmROYcwaOj8OOeDTT
ts07cOhvUtasvj0ZGZoHQUh3qp1z0PVUn88r76hComwC5Pdzu/PCvQzEDOTHWR56
fdYyWyo6DM1KUgRvRrkSnZyQVdCfnCvc7f7GLF87iytmFY4m9QUJpyDxcbvGNME6
3RjXHSsVI8rz5w1zAykeWYNNefWFEmgrT5mXOju50D1R7DCDnSLsGEPuBfoqzZW/
lF8X40iKHhV7YFMsxfPuKitw1j3M1N2zZxnKSbRF/jybscyLQy6W/na/vhs6BImb
zXWf60HpTKhst0Hge30CAHCtZObw1CkZpLxH2fo1bGavY2jKOt/XJ7tvYMLebB1I
+ovDQjR06BOdS+OEShVPs0pKNl7nSYNfpqHstqcdepHj7Zxdc2uHTG3eHzeNtaU0
XmVz3jkJj3yHWUjK0oBEsCsW1QT2wQC2qTN7TzV3u/ReSKC7YSQH4evk6h5SMzim
tTQ6qM83smI=
=4kaG
-----END PGP SIGNATURE-----

--=-Sngji6coMPiDiyN2Hwg0--
