Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58620 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbXIXR0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 13:26:40 -0400
Subject: Re: [PATCH 1/2 try 2] Net: ath5k, split hw into hw, phy and  initvals
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, mickflemm@gmail.com,
	Christoph Hellwig <hch@infradead.org>
In-Reply-To: <43e72e890709241024pd364c31k4a41c030f192cf0d@mail.gmail.com>
References: <3175698652466923884@pripojeni.net>
	 <43e72e890709241024pd364c31k4a41c030f192cf0d@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fOnFPrpoHlq9yjtdyEw2"
Date: Mon, 24 Sep 2007 19:27:56 +0200
Message-Id: <1190654876.18521.276.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fOnFPrpoHlq9yjtdyEw2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-24 at 13:24 -0400, Luis R. Rodriguez wrote:

> * ath5k_hw_set_rfgain_opt() is defined once and used once, can we
> instead make it inline? If we really are not going to re-use this
> later why do we put it into a routine on its own?

Why mark it inline then? The compiler will inline it anyway if it's only
used once. And I haven't looked at the code but making it an own routine
could possibly make the code more readable, especially if lots of
indentation is involved.`

johannes

--=-fOnFPrpoHlq9yjtdyEw2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG9/Oc/ETPhpq3jKURAmKiAKC6gTZO1prnTavPh24ppNDegt/yigCgsoiA
NQtNJeIz6wVGNwQBjKH5cU4=
=ppl0
-----END PGP SIGNATURE-----

--=-fOnFPrpoHlq9yjtdyEw2--

