Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35141 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbXLLRmt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 12:42:49 -0500
Subject: Re: [PATCH v2] introduce WEXT scan capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jean Tourrilhes <jt@hpl.hp.com>,
	linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>
In-Reply-To: <43e72e890712120858y4141d894j6b8e71a72a36dfe4@mail.gmail.com> (sfid-20071212_165832_508058_EDE585E0)
References: <1197473107.12484.3.camel@localhost.localdomain>
	 <43e72e890712120858y4141d894j6b8e71a72a36dfe4@mail.gmail.com>
	 (sfid-20071212_165832_508058_EDE585E0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z+hGoAt9RqiyF4AnoFmy"
Date: Wed, 12 Dec 2007 18:41:31 +0100
Message-Id: <1197481291.6558.136.camel@johannes.berg> (sfid-20071212_174256_690566_37856CF9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z+hGoAt9RqiyF4AnoFmy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Oh well... Would you mind putting this on enum and kerneldoc'ing them?
> I'm not sure what some of these would imply capabilities for.

kerneldoc isn't very useful on that file and nobody's going to convert
all the comments there any more.

johannes

--=-z+hGoAt9RqiyF4AnoFmy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2AdSqVg1VMiehFYAQLq+Q//U6u4GCOWUcXV5lLR39ucjd50pBEgMMls
4k7bGHQ06qXMk3n8k3b8YTWhoubcJS0Z6nU7KMrJ4v4vJdpNVEA2pPEmqT+JvnMz
dIREG4qnVp8DEYtXCem/UCHIcLI4j/Xt5H4Ic7+iOn+jouCEv06fLwaLhy/0MtFW
wTCPpMgAqLmx+xD4IsbU5+sBt1f6k24vb0Tgl/Un/dq6a8ZeO7Go2W0e5UN2RBix
a4GUkywjvV5T6Zn7IKIMtJM8uH4rQz2Ig5hy4Q6vbE4CqfnGAcv87SLjtAhketg7
zJaG8jKD0s6M5hG1U7C8tsWGyVGjcGUHEm4n/ju6PhhvthHgTX1yWaTZX/UNB929
4xHMLf2/qViuDLtVlTom/WNqmmHGARbybZ6VFglIvykSfV+hXyyp3c1/Fy8GaJpF
VP55lHFdVSBFYrPH1peC25YEWLu6WyBmlmkJWXRWzhLBsGmB1yYapqNoE1BtsCIW
YKueqsL54blPGgdh0BL7iHfj46AWnIbAnQZdG5WUPY7u3SG7V2nllGlvMlxQX8sa
dZD9PvmLFlQUQQEIzBtaFNXNLsbJKtqU6i6Vkok/dKU+nUGa/z7GWdIl/b5waZo/
4yXrcY5s6dDm51REyW6nDpJb78Cao97AQ7Y1ZlQoKxUBrik+gCxf4s1Ly7ye3LLk
IYH2w5IZxe4=
=ALI1
-----END PGP SIGNATURE-----

--=-z+hGoAt9RqiyF4AnoFmy--

