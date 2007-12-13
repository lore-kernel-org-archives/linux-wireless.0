Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbXLMLm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 06:42:29 -0500
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
	learning algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1197489986.7491.11.camel@localhost> (sfid-20071212_200658_771608_5D92BC72)
References: <20071209211547.2d7fca32@morte> <20071209211931.26ff42fa@morte>
	 <1197239150.7543.13.camel@localhost>  <20071210090853.79ea4645@morte>
	 <1197319867.7493.4.camel@localhost>
	 (sfid-20071210_205142_109612_504EEC93)  <1197384754.4037.23.camel@johannes.berg>
	 <1197393788.7528.5.camel@localhost>
	 (sfid-20071211_172341_980688_FC3BC8E2)  <1197479594.6558.122.camel@johannes.berg>
	 <1197489986.7491.11.camel@localhost> (sfid-20071212_200658_771608_5D92BC72)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9Ex2tXJ+XALQyMMkAxLy"
Date: Thu, 13 Dec 2007 12:42:23 +0100
Message-Id: <1197546143.6558.249.camel@johannes.berg> (sfid-20071213_114231_959364_828BDB11)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9Ex2tXJ+XALQyMMkAxLy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I'm pretty sure we currently don't support switching modulations via
> WEXT. Any ideas on how this is going to be implemented with nl80211?

The way I see it, I'm going to rip out the whole *mode* stuff completely
and drill it down to
 (1) pure frequencies (no channels)
 (2) supported rates (which implies modulations)

> Should we be able to switch e.g. from 802.11g to 802.11b while the
> interface is up?

Probably not.

> Anyway, I think we don't need any special handling of this situation at
> the moment. The stack needs more nl80211/cfg80211 work anyway, so let's
> fix this once we've fixed the stack.

Right.

johannes

--=-9Ex2tXJ+XALQyMMkAxLy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2EanqVg1VMiehFYAQLYmQ//c3dl34YxB7+mjPTijV3l0UADbTKy2gO5
sYOT8GM3g0XxayGFVkEf+juyatoe44B9ta6N9DDqCeNP/Zl/wlgTpyc28qBA1F1k
9y+dRpLMi2EbgyBuziF5zAe9dUwyh2MyKDZsGqqnbrdsIgU/ONdp+w+pbbBj3FSV
XMtDXG8sLwYI76Lj2n6JwawWCc1ZfM4D0cZRvNVo0hn3MKN1GR8CEPIDJz2FDHCZ
5T4rMwgge3P/v06Ya6nwgUohL0ZyvM+YIogAIKs8bSrm3rP3x0yT4lSUVk399tTb
XoAxtn8aPsZ9SzKckydyA5v3aQ4L587Pff08h/RB2qjUQsFDvdX2ofhjRWLE0gMA
y1//nokMsxtg7296PJycY1COXsNT+vM937LEeBoi/yQNNLcLYat19KSjGiMbMd7k
AvkdIBRAS7sp7gpQ5otthgEJQBjEavWYgCJRJcL1zriWcAbwtUaxPq26vAf4uA56
YXiKlSyKNfttVIbEbE3Ualth1mypn5MslKZ8HASGPUx77fhtuJAn/mzn+1JtBpP+
kzarzEQkLX75fb6MKkzUw7GNcUXQuT6Rs/lvHNlaP0jP2dHebiXiK7SeWkl72is/
GNbDNNSMqUoTX3oriMHvbwhO72/ICYCPNFcVF4/MXYIOJrUBipqeuvpGOSXZqqu8
SOMYBdHH2lk=
=PQEr
-----END PGP SIGNATURE-----

--=-9Ex2tXJ+XALQyMMkAxLy--

