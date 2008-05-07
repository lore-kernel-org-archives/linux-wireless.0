Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36576 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYEGXbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 19:31:37 -0400
Subject: Re: iwlwifi and tx info in skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240805071629i6c7336f6y61a7c9690820ef5e@mail.gmail.com> (sfid-20080508_012814_147541_06BCC3D1)
References: <1210197711.3547.1.camel@johannes.berg>
	 <1ba2fa240805071629i6c7336f6y61a7c9690820ef5e@mail.gmail.com>
	 (sfid-20080508_012814_147541_06BCC3D1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MUTu9T5MqtWnbtWfxJqk"
Date: Thu, 08 May 2008 01:30:53 +0200
Message-Id: <1210203054.3547.12.camel@johannes.berg> (sfid-20080508_013040_922949_3E071112)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MUTu9T5MqtWnbtWfxJqk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  What is a TFD, and why can it have multiple SKBs with a single tx
> >  status? I'm referring to:
>=20
> TFD stands for TX File Descriptor

Huh, "file"?

Anyway,

> This is for scatter gather. Nothing to do with aggregation. If you get
> fragmented frame you can send it out without linearizing in CPU. in
> numer of TB - TX buffers (which is limitted bu MAX_NUM_OF_TBS)  But
> I'm just over ever explaining :)

We don't support that in mac80211 right now, why do you have that there?

johannes

--=-MUTu9T5MqtWnbtWfxJqk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCI7rKVg1VMiehFYAQLLsxAAnUptNlzwBrpaDkxeBBAcNjh6o1l9E+jj
/9KStUoFMen58NdrP/h23VaW9MA2v5c6EVw+ubMoUQNBcHJUvaawAXL7pEjZuvjQ
zgq1UKjZO6qC2cn1AJlf2aWvRZeXjSyRTBpMyxYrQUwXV0Bg8Q1v5O1a6RKsxC3B
r6T/yxtd7We6RAnP8sc/hYot8qmAInV1uri1Lq/Kjcyg1v+bZAuXf3N4XfR7BFY0
j9rJuB+rdkpKrwdPILuVGStUTl4+kkRMyOQmjAAa2fIpRYr/swcpo8RGYqD/EJNm
Wx7FxkZdbieXhvxe+1iH9fHfLf4Tb4Y+owk12B6ZIyuX7iSdjDFeb91L9UgqqIY4
SGz1M16Z6GL1GI/scqbErbFq5YotmQtHAGq5XpwdOqtIQWnigfH91+sWI908eMSw
8gTFII5BNqvptuJ+bfqqoJp1MR9euDoShlcvhZXBK4PBnJ5yzJ+mFnW3XvZsMPkl
uLeSzYLSY/Tdmt0GjXGfOB8WHY/ya9ClaZdP8ejJfZofcjh60qiGQcy0omLvUVBG
GKNltS6rykb6Qhl/Hos1CY3V+digwQl16D2l+mtFI03VwAO9oYO9fRTXdsID9HOY
MbGt3Ux0aPEzSW4tnOg91y8GBNScW1rpoNUqyXPM5EwBXqKkf8XowGqI7W0RBXpa
9xzTba3Qy5o=
=Mseb
-----END PGP SIGNATURE-----

--=-MUTu9T5MqtWnbtWfxJqk--

