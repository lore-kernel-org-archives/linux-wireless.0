Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44204 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZH0HPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 03:15:11 -0400
Subject: Re: hal, rfkill and compat-wireless (Re: [RFC/RFT] rtl8187:
 Implement  rfkill support)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>, hal@lists.freedesktop.org,
	htl10@users.sourceforge.net,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890908261645n24a040cds84f012095a40c15b@mail.gmail.com>
References: <3ace41890908261511i3056c049kca82831015ff2aa0@mail.gmail.com>
	 <43e72e890908261528m23b8fe78w209e305f27e68fa1@mail.gmail.com>
	 <3ace41890908261555g339e65d1n6627cc3d1713287e@mail.gmail.com>
	 <43e72e890908261645n24a040cds84f012095a40c15b@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QzPeNyo3eGpSnl+4pq8J"
Date: Thu, 27 Aug 2009 09:14:27 +0200
Message-Id: <1251357267.20531.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QzPeNyo3eGpSnl+4pq8J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-26 at 16:45 -0700, Luis R. Rodriguez wrote:

> Johannes, did kernels < 2.6.31 have /sys/class/rfkill ?

Yes, but I never understood why that matters. If you've got
compat-wireless "rfkill" loaded then the original rfkill can't be loaded
anyway. And their symbols would probably clash anyway if the original is
built in, in which case you can't use compat.

You haven't renamed cfg80211's sysfs either, so why rfkill?

johannes

--=-QzPeNyo3eGpSnl+4pq8J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKljJMAAoJEODzc/N7+Qma4T4P/jZ5TIYrErrDo9s8wW7H7hy2
Fa8xlLJew6sB7s4Nt4904wEEP7a10Lms0QvFZMvkjjc8N89A7YEGbQehy/W76NKq
Le0E8tlokS76hpjiRxeUjBP17GXQdCorpd3oowEZ78wK7LwuIymz4BsxDOwbsnUj
xGvLh0bibrZzRvxu4cm8IrBBfktNn+vw8G+UIJd232CRR7UoeBkRABfYyGXg4/u5
djtrVppGLFkgiS8Hn+XlE7/Q1v1d2SD4m602YbLEuXlUGgWh1bi0UHsciPZm59fa
vRORs+01sOM6kcbL4jU1OZF/u997YBaL+Zn4Xc8DLqdbHQCqFyEL9GhK8PPAuAaP
FLv5RnokbwMuZOHh43CeXvkS5ovF2shRlIMXVCwkcedd0TYDx5V/8Xs/+tgKkGZL
2VXbOOAW6mQAbayACipTGLncwidbaRSXmB5vw9MFQpMZY5ljAsIYO1+4qDQUvcIH
i1HurmvHU/6pN1LSTWt4FifjH8gXByEHwEIkwA1PXgZOds89s77NQw8SrHWyyvmq
Kd94yCdFyaIaJTYNQvqxcUOOxanb1VpTMG4O0Is8V9FeV9mGYb8ibVIgUFT8A+oX
97BoTpzL6gYqsYOhgLjTlWYA59d2/+mJ6Q7y6g9QVhxm95renTy76dLVL0n6eqEY
cDgDBK6KiyHl6oWvy0B+
=w+uS
-----END PGP SIGNATURE-----

--=-QzPeNyo3eGpSnl+4pq8J--

