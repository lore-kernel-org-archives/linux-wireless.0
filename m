Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50203 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbXIYTSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 15:18:12 -0400
Subject: Re: A-MSDU deaggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: mohamed salim abbas <mabbaswireless@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1ba2fa240709100441o421653fbre410df615e7d9e10@mail.gmail.com>
References: <1189354526.4506.25.camel@johannes.berg>
	 <1ba2fa240709100441o421653fbre410df615e7d9e10@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2hC9OBIsg8RqSLyDEqtL"
Date: Tue, 25 Sep 2007 21:19:26 +0200
Message-Id: <1190747966.18521.320.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2hC9OBIsg8RqSLyDEqtL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-10 at 14:41 +0300, Tomas Winkler wrote:

> There is actually different problem with the A-MSDU deaggregation and
> this is EPOL filtering. One of the packets might belong to EAPOL
> handshake

Why do we filter those anyway? What's wrong with having them show up on
the regular 802.3 framed interface all the time? Isn't that how 802.1X
was basically designed?

johannes

--=-2hC9OBIsg8RqSLyDEqtL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+V8+/ETPhpq3jKURAo54AJ91Ufu0LNIEfhgSttIgKBWPDm5ZKwCeIHAo
4GuubkPlPJ3TSS1rPPdUjrU=
=04J8
-----END PGP SIGNATURE-----

--=-2hC9OBIsg8RqSLyDEqtL--

