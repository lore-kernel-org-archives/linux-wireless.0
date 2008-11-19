Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54484 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYKSUa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 15:30:57 -0500
Subject: Re: [PATCH ] zd1211rw: enable master mode. (wireless-testing)
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Rami Rosen <ramirose@gmail.com>, linux-wireless@vger.kernel.org,
	kune@deine-taler.de, Jouni Malinen <j@w1.fi>
In-Reply-To: <20081119160135.GB3485@tuxdriver.com>
References: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com>
	 <1226943608.3902.36.camel@johannes.berg>
	 <eb3ff54b0811190559g39c2176h86bd9fb1956d6730@mail.gmail.com>
	 <1227106146.26243.43.camel@johannes.berg>
	 <eb3ff54b0811190709q76e8b073ic71831fd38ceba18@mail.gmail.com>
	 <1227107869.26243.52.camel@johannes.berg>
	 <20081119160135.GB3485@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LtU/X96UNaHbVE/p4Gu1"
Date: Wed, 19 Nov 2008 21:30:19 +0100
Message-Id: <1227126620.26243.71.camel@johannes.berg> (sfid-20081119_213102_886541_67293718)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LtU/X96UNaHbVE/p4Gu1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 11:01 -0500, John W. Linville wrote:

> Is there some way we could take that into account?  I'm sure there
> are users who would prefer to have an AP (i.e. their laptop) that
> can't support PS clients rather than not having an AP at all.

That's a good question. The distinction here is between empowering users
to do the wrong thing (AP without proper PS support) and enforcing the
right thing (with the consequence of complete loss of AP functionality).
The issue I see here is that users will see "ohh shiny, AP support"
without knowing that it doesn't actually really support it. Not sure
which side of the line we want to stand on, I prefer the correctness
side but I can see arguments for the other side, would just like to have
users know. Maybe we could have some way to tell hostapd this and then
have hostapd print a huge warning about it when started up?

johannes

--=-LtU/X96UNaHbVE/p4Gu1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJHdYAAoJEKVg1VMiehFY11sP+wUiFKJb4tvabqhpaVOSBdYi
UvC7pJthpIp078/uy71Z9tqXLoKpAF0HBtQY36geY+Ia14L0jWb5yzj6uE57Z6DV
D8tP5sGV3FmpJq5wWAYqeJAbcD4zQjyVoW4s8G2Ov1uAVAuGGb8o2vHR/LebkfEz
DeQgh7NIjRUHhWo1b+F1KL+O/xW8LbtmhbbCijOH52E//ntHXBQu4Iwojd7MP73j
KCqEvnUKcpkq8llYgcDIjmRzAsi0yYEjqGvmwttu1kN/8ixNTx7lEAnebexbGlD/
4Qwn5TQv6b8/Ziryw8bRuekpZ9deuD5wetHclBcJMEK4eVlX+gZU26U9xka1YVX/
IxkOopv+0B3bWzshSllkuq4dWiGQ0mqzkVtRZKxd+h+XFBqmgNsmk2oiOF1e4ir8
ftAiUhCA9vD3Ar2uY17bAur06viYSfh5FEBBm3Ri6pISFOXSUjZskk2cmeeIIyPL
mc3uvAVUadFlPhtpNR7vG+iQm+/JmbC/Vl9pRRCR+pVwuIALIzIXqacE1RJ9+KGw
utKmB7KHa8sHEY2OAp63wbPCC+rw6PgHsKZB7d4clZk5S94p4xRNgLDe1Mj14L0h
8E/u4KINwk1iGylxKuNl30yW/IU0Hf9VOPe1P9RH31riDrD9gbm7+MtPyk9Z1wvD
VBZm+Vz39t/9ksGNCcqw
=8nQ5
-----END PGP SIGNATURE-----

--=-LtU/X96UNaHbVE/p4Gu1--

