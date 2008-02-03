Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35144 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbYBCOhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:37:31 -0500
Subject: Re: cfg80211 API changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240802030555v28873634wceff4ecea67d3530@mail.gmail.com> (sfid-20080203_135528_899836_950D59B4)
References: <1ba2fa240802030539h132c7365g1bc1c20b1c560c0@mail.gmail.com>
	 <1ba2fa240802030555v28873634wceff4ecea67d3530@mail.gmail.com>
	 (sfid-20080203_135528_899836_950D59B4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2S/I2o3FqIkNZmDvW5Bc"
Date: Sun, 03 Feb 2008 15:37:24 +0100
Message-Id: <1202049444.4188.125.camel@johannes.berg> (sfid-20080203_143734_919608_0436F51D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2S/I2o3FqIkNZmDvW5Bc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I'm finding it a bit cumbersome,. now when tx_rate is pointer and
> doesn't resides in the ieee80211_tx_control
> I've seen in your patch you've just ripped this code off but our rate
> scale algorithms doesn't work without it actually the code that read
> this value in rate scale algorithm is there but it actually looking
> into empty space...
>=20
>  -       tx_status->control.tx_rate =3D
>  -               iwl4965_hw_get_rate_n_flags(tx_resp->rate_n_flags);
>=20
>  I'm just asking if you had something in mind or it's just something you =
forgot.

TBH, that confused me completely since the rate scale algorithm tells
the hardware what rate to use so why does the hw need to assign a
different rate in the tx status?

johannes

--=-2S/I2o3FqIkNZmDvW5Bc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6XRo6Vg1VMiehFYAQJ0oBAAo7yWV6zF0lLrNxBFuE+zXrjmy8Kh59qs
8oQK/L8jYSU97mbiFQkqgJAsh41bAkP61lVjYi35Wg9CJVuYrMqclxNMzEmcB3r/
7VK1ya8aGMVT6qNF0FSzQLeJd3o7/2/Epe03XgNv+PiWVCgZvTQdC9tM+z6gM5G+
mUptQ6yP3mfLiNDKkGRTdSHIOKS3FxqUVdF7ncpbLRTbvWwFxNlP8xeuGAnK3Frk
rxaW6sLdR8TKKxno3PuNAOlyYaEvSVvGVZ494VrhJGMmU0dK14sFRrhJYq3xwfAF
Nv1z5BbpOiw2Y+TfWuUppuGBYGWClYTPmP8iVxxqJ0cCil2Gb6sSX/P+fgXZwtzt
Ky7hF9kORS3Z0W2/ufpowi3Le3jl2EHVni350US3I2oY0ajlr8Kr2oeR67KEPH6n
fi/wCcJQDydapmMju8qyIt1PpnbRrtMMuEZWbfEmk2d9FOMeoGp8IvT+HdYK8EqD
2iPDgafPGqy8Yxv82G7ozS3ZT1vxxZTEOVoYAs/Rz/lmLj52siBuVubW2I8YdqWc
6LRaxykrf658r/N81KCxxp+zEeKthBERmu2xAcA8ADiZ6Kz9QbsRmBBcT4bls8b1
lvI0s1/FtQ9ZMaM9h83siV5dK3QDkVi2CAEJ1mh0BYpYmuh2LPFLgcj7YA736krI
84ifMGf3BAM=
=sGtT
-----END PGP SIGNATURE-----

--=-2S/I2o3FqIkNZmDvW5Bc--

