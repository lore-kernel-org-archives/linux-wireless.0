Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802AbYCYQWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 12:22:09 -0400
Subject: Re: [PATCH] mac80211: silently accept deletion of non-existant key
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1206459795-18167-1-git-send-email-linville@tuxdriver.com> (sfid-20080325_160740_822036_736A9E3D)
References: <1206459795-18167-1-git-send-email-linville@tuxdriver.com>
	 (sfid-20080325_160740_822036_736A9E3D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dcejzNogNtBf2EI6a3vx"
Date: Tue, 25 Mar 2008 17:22:05 +0100
Message-Id: <1206462125.16475.303.camel@johannes.berg> (sfid-20080325_162216_168682_3717FD08)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dcejzNogNtBf2EI6a3vx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-03-25 at 11:43 -0400, John W. Linville wrote:
> From: John W. Linville <linville@linville-t41.local>
>=20
> Otherwise, 'iwconfig wlan0 key off' with no key set results in:
>=20
> 	Error for wireless request "Set Encode" (8B2A) :
> 	    SET failed on device wlan0 ; No such file or directory.

And what is the problem with us telling iwconfig that there was no key?
You should argue for iwconfig ignoring that particular problem, but I
don't think we should do so in the kernel.

johannes

--=-dcejzNogNtBf2EI6a3vx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+kmrKVg1VMiehFYAQIUTg/+L/4Vrb4WaPg9AKo2F+I7NskELhH8sYSd
q57I8XZdcU/lKNQV9Ojv7gZXrmbmR/ryqZap0FxQl9Vy+eAn7+XXL+M4q5hSSS6c
m9R1v7R8ePsPfc1nWKbUf9bKAyX4QfOPJH/2UjsmXuW1OS/KkJ2PC6nNCm1Kh8Tv
KX0NWdPe6MwfVVPQyvla+QZSpGHPjE2h2WmvCYT5X7uN5Jr+Pk1W2WL080ufM7mN
jtgJIOjWpBSaT8dIcBvU/WylnWPVl97Ldkmbkg/QKrqFjBafyeOOpf1aR6jXeN3l
qqkYtD8Eiyaud6SEUkT8ycEF5wyHbcI9H/sQY3DBuiYUoarG+8Q7SkbqOpy72gwH
kNyh5NSIXPqNY7zTXXsBH1hj8uWDXX1ttUJHMnios6qgWpQicwDJnpK9Wkeu9fc7
KgBOSaNnhpWjSSX7Qz0EN9nB65syIXphfTC+gW+gx4nG/hEDXfYxTQCWXSAVqkmQ
0Nema+FHgAyShf7V2ROrLItaVxBQkD4RjmGa/XNq9xTa+PEZV/LVPE/IIT1MFCWg
PDFN4jqDMNn9fstqsrCnAxsh+RY6aKC/pvaDeBPpIljGF16lFvhF9BSDOiJKnIdD
1VWo1S6F5Xe61ryHs0jm4nh+R3jcSUc8GAhc/QSgfVA0K827SZDym+fSXLfD1WqV
2dpUvPaaB6A=
=N7xq
-----END PGP SIGNATURE-----

--=-dcejzNogNtBf2EI6a3vx--

