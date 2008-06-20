Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43554 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbYFTGti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 02:49:38 -0400
Subject: Re: [PATCH] adm8211: remove masking of protected bit
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1213932851.6591.8.camel@brick> (sfid-20080620_053429_400940_138640D9)
References: <1213932851.6591.8.camel@brick>
	 (sfid-20080620_053429_400940_138640D9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DBMAgHhtdAR5wSAzaNIQ"
Date: Fri, 20 Jun 2008 08:48:59 +0200
Message-Id: <1213944539.8967.127.camel@johannes.berg> (sfid-20080620_084942_059239_2A235685)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DBMAgHhtdAR5wSAzaNIQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-19 at 20:34 -0700, Harvey Harrison wrote:
> Use the ieee80211_hdrlen helper to avoid byteshifting.
>=20
> The masking of the protected bit made the two tests below never trigger.

> I'm not sure if this was intentional, please review.  If it was intention=
al
> the two if-blocks should probably be deleted.

It was intentional, I think I asked before, adm8211 doesn't support hw
crypto. But I agree, those code blocks should be deleted since the
driver shouldn't use that bit anyway to detect whether to do hw crypto
or not.

johannes

--=-DBMAgHhtdAR5wSAzaNIQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIW1LXAAoJEKVg1VMiehFYHcwP/itIEBDZnCoB+DwozmVuEzpt
L95nX96jyq9n8SjqToCidLNt15MvxfeOO5r2C++KsAhNvVUXyzozoM1bGMiP7maf
ApqtIylIHjk1BAFo7AugKHpWWBt5HWi6E1sf13UPFTCMZV4s7lTmudjlCGrRmnjB
RcucrbKostMBFSGf0gch+VHdfgLjEp8O+VKTwRScZsrGcWbcYfK0HVdlOZzoiXji
XE+JBDYqX/pSKuDCnJfGsqAP0XQrWWzfti2c1eU7vYu8ypBDh3Hoc6vnjH0ewLF/
jiu5/8epP0j0/DVnbLIsGZ8pkJeC9/Q/qFWFWHEp4VxgCdydfeDbV6qhNcQ3RVfB
P2YUlh4nGV/EJJw9BkNpuJ7iU6MDH6cOHwOY5nKUM0nvTbXxCO6zaRChjUF6k6gM
08VEuIUMz/jSI1Gdk4eYMEz18t8gQDnvTcVZElXnO9IlvydJ9/6YlyFWt6Esv/W6
EECJ5lt+cz20dYWkJ3HtG/2zdimlsfwCoB3VQbL8H1YuuQun7TRLwVu6073bASGj
R0TenoBCrLDPJqhbzrse5KVLC21JfVC+6l+DZr5Pndb4S689AJw02eOXvJ9tO9uQ
FywNc8rIb+Al93GtQtebRTjdBG0lW81PHamp2xmuGYIdrLxa+u3xCiFnVdZteKI3
cJyO1RlCKdzOXbD/Q6Dm
=XLMk
-----END PGP SIGNATURE-----

--=-DBMAgHhtdAR5wSAzaNIQ--

