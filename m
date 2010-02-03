Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45038 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab0BCJqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 04:46:25 -0500
Subject: Re: [PATCH] mac80211_hwsim: add fake hw scan handler
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <201002031036.19942.holgerschurig@gmail.com>
References: <1265188851.29119.84.camel@johannes.local>
	 <201002031036.19942.holgerschurig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HqlC56Mz313mWIIz5a/I"
Date: Wed, 03 Feb 2010 10:46:21 +0100
Message-ID: <1265190381.29119.88.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HqlC56Mz313mWIIz5a/I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-02-03 at 10:36 +0100, Holger Schurig wrote:
> > +	for (i =3D 0; i < req->n_channels; i++)
> > +		printk(KERN_DEBUG "hwsim can chan %d\n",
> > +			req->channels[i]->center_freq);
>=20
> Should that be
>=20
>   printk(KERN_DEBUG "hwsim scan chan %d\n",
>                            ^
>   (missing s)

Heh, yeah I guess it should, thanks.

johannes

--=-HqlC56Mz313mWIIz5a/I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLaUXpAAoJEODzc/N7+Qma/9QQAKOaX9iN8OhhREWtgHstdZHj
TG9TAp2eBZbSgJuRsr6Gp9sIkipETIVr6qXaC7D5CJI3AX67SpLTlgbU5WxvcDIP
7I+aN7tt3mhFCrjPYF0cDOyr57b6BjwYlE8S4TTeh2D95V1VzZH8mz+Zox7nCqha
NOVRhYUQ0aT3ONW6lh5AWdHFP3o1Kl0N2vT8nZAp8qUXXN3wRrRE8inxVVuhK6Xw
5dELgee9F41WgvqkxmuR1nTjqOaJfy6IXyqzXywqzO5XvUaWebjCLLWFHji0pmae
Td5dmfJwnC3jdFuwPa8E2AjJlC3RtDoXuwfWm6nkfRvvtk0SPYT14wOwYQpRWACN
ODnmNfj7Zspm0qc26eF33qVKxM1sBD3RXwwcgvHKCTkhN2l5feoihpwTr4rxzH+x
3Asck5o94zWOglQQZIHinqTvGIQCNf1pqjVacI+N9F51ilnPTaiBA0usUTQUnz2l
zKK2ojOL8hAps5NZnn0Ln3Hs6CqS765F0+Xbc1bx/QPf/TFg1N3hDinW7v35+VSx
2rNjbzsstDo9uiVvkcWrzBFxMUsI6PDmVj1QqCRXhLLEZ/1sFYL+VgT5QQgtKYs0
tioAhoOKhvCikOz62V9rboC0ZvO4CSDP+OQY/RHfKLALcPphHGIgSJ0qMjx8EjA5
WDurcLccrzC33J+COczE
=o8wn
-----END PGP SIGNATURE-----

--=-HqlC56Mz313mWIIz5a/I--

