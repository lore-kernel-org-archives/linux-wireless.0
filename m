Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38938 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZHRI0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 04:26:35 -0400
Subject: Re: [PATCH 09/29] mwl8k: remove usage of deprecated radio_enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090818082537.GK18639@mail.wantstofly.org>
References: <20090818035220.GN18639@mail.wantstofly.org>
	 <1250580509.30538.2.camel@johannes.local>
	 <20090818082537.GK18639@mail.wantstofly.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jR6uJCAhyltAZC6cSJWk"
Date: Tue, 18 Aug 2009 10:26:33 +0200
Message-Id: <1250583993.30538.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jR6uJCAhyltAZC6cSJWk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-18 at 10:25 +0200, Lennert Buytenhek wrote:

> The logic is just:
>=20
> 	if (idle) {
> 		issue "radio disable" command
> 	} else {
> 		issue "radio enable" command
> 		set channel
> 		set tx power
> 		set antenna config
> 	}
>=20
> So if a channel change hapens while we are idle, that event won't get
> lost -- it'll just happen later.

Ok, yeah, that looks fine.

johannes

--=-jR6uJCAhyltAZC6cSJWk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKimW1AAoJEODzc/N7+QmaZEsP+wRICSau3p8vGY+++PtiKMBU
Ec962b+hS8fHoXN8sUJ37Wywb5VEJ8RDDAIxYFkaCAxBLtwIm8znPpgGV2OXVuKb
TtIxw98C6zP/FEJV70p2fXAqooAw/ne+wqV+bP6AueKSSyZywAvedAdQNRuhvghJ
9tMLZY0pt7ciBCX8Zd4LNqA+FfkpVulMc3847FnY3mkjwfybclhF31K8SQPJhYhG
wxDpY4ttWI9RE+CjcLgyLtCpn5Uou3zJaQhnUbPLgAvGcu5NzbydBZY6q0iR+jek
NIlsXyp2zfzsp26/A6NyB/qsrODrjKtavH3v0H4ZI7lo880k1W/MclUkROKLdCYd
+Phubc9QeEss3ggVowUsM0/WflRai4vrIrefUcO7GnWwlCs1sLi/k1Vi3tQ72vXv
DH+YPCDhux7YuAPyae/FpXC/KX1Mtfp284FcrkQ44r2H088O167mhc6NTlVkiEGQ
vO/TnmqrIHrvQD69purlSXsSf6rXSENEhCbwtCkW7oCWMlko+V1JtxQqs8qtuqon
zUp/SKX9DfSYvgYCSoad3OQ0V/Qhg7I6KolbE5SkCMXEWp0rpywORJTZ8jm0Juck
v0PCmxLeB2QyBs5jDGG90c+/JaNTjsm4A0aqaIPpcxOullOROpM6NlubzuxKvO5l
9fvY+5XmlQ+yMgMOvzYH
=BUgF
-----END PGP SIGNATURE-----

--=-jR6uJCAhyltAZC6cSJWk--

