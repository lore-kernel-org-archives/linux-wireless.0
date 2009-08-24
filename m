Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55682 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZHXPd5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 11:33:57 -0400
Subject: Re: driver_nl80211 broken again
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1251117161.22951.4.camel@maxim-laptop>
References: <1251117161.22951.4.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tQpeKxHDfsnPzPMgbwyC"
Date: Mon, 24 Aug 2009 16:08:05 +0200
Message-Id: <1251122885.12007.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tQpeKxHDfsnPzPMgbwyC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-24 at 15:32 +0300, Maxim Levitsky wrote:
> First connection works fine, but all following connections hang
> wpa_supplicant hard, and more than that, this is first time,
> NetworkManager confused that much that it refuses flat to connect to my
> network, even if I  reload the wireless stack.
>=20
> Only way to connect again, is to reload wireless stack, restart
> wpa_supplicant, and restart NM, and this helps, only for one more shot.
>=20
> My network is WPA2 protected, I use iwl3945, this is quite recent
> regression (of course I use tip of wireless-testing)

Need more info, works ok here (hwsim).

johannes

--=-tQpeKxHDfsnPzPMgbwyC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKkp7BAAoJEODzc/N7+Qma/NsQAIH+JXBPyW9UZK/NQn0rA/uE
PwJJOBKwaHktfP+Lr0MHBuLFswP4fOCIfQOaKpgnT3LGUGNUqvV5UMzkJJhEp+Z0
j6O4vGizcpILgXsaKKqy4XpUYxDxtZD9YvYe2onCMrujf8H8IWnyMB09iu2BUZpB
+oYjMy4jzAsBl5HWtIRb9qq96bwZGt6LEkr71BvniWFn5cBF2h3tcPQtzgMa2EEz
7jO7jH7icJfhDqHkKEzuNTnv+nA1v1HOMA48OUHON2Sd96Il09SQDe4q9maMp7Nj
7tPYztC1ryMnonuK/NsUlsOeb2Yx+0Xt0A/c0c/ZxJpiDlQ5E8+77neerB263sJy
VIz3EUAkqc9IVr/nOw1HJja5eiQX2vKHaMgtUA+wA4/KIaoSmxJmx/aMuh7swfBz
LS64BJ1Aahm3KzTa9OKqpsztonv2NyAA8oiyUb9FO/SqZewCL7aJHF7Xj5gCVG1R
8/Z4hdx/c1m94fK+tIx4ZM2AwrVfPMf/ZYlQcGiwxf+DWg0d5eFz5eoquilxFUsg
9KB4IGz9Dfwb/k5cnPiPprkqMnWVKHtCCsT9hwFEOdobYCfLhoX1o+3fJ5oftRGY
t/4YvfSkpkNnrVT+wG9izhmfEtC1FShJL6nnLIn2hJAH7VnRykZcXaWjWPHzxpVs
q76X8Wl2Tti9n+2D4SGW
=0ZA4
-----END PGP SIGNATURE-----

--=-tQpeKxHDfsnPzPMgbwyC--

