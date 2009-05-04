Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54330 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbZEDLhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 07:37:48 -0400
Subject: Re: [PATCH] add basic support for parsing country information
 element
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241435567.8683.35.camel@johannes.local>
References: <1241413787-3185-1-git-send-email-marcel@holtmann.org>
	 <1241423772.8683.8.camel@johannes.local>
	 <1241423924.8683.9.camel@johannes.local>
	 <1241427107.2899.9.camel@localhost.localdomain>
	 <1241435567.8683.35.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bJvfEdoDR2BbDHv1b4m+"
Date: Mon, 04 May 2009 13:37:15 +0200
Message-Id: <1241437035.8683.37.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bJvfEdoDR2BbDHv1b4m+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Marcel,

> I've committed everything, and am doing some minor cleanups. I also
> noticed we don't validate everything as good as we should so I'm adding
> some support for that.

I've done that now, and pushed it out, but I think the RSN IE printing
you added (and I renamed to print_rsn_ie) is missing some input length
validation, could you take a look at that please? In particular it takes
the count from the IE, but doesn't verify it fits, I think?

johannes

--=-bJvfEdoDR2BbDHv1b4m+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/tNoAAoJEKVg1VMiehFYsU8QAI0tP6uTyr9Rg/964q28M1D0
41hmLbJs2hAcvVxYeGHqUj7OvCAf7H8SDz7cpSuaOhTDKRGrwISxJtlXIiprcOSh
9r+UEtJBqEzQXXhPJN2OAVxK3/g6FGjErdgVDZGI7EbiyWm0ZHMPsvsSkpkr0Sez
8v5wTeye+MHJF/O0ypROUiEQpIH483JNkgy1T/5Ek8sqvMHN3H9LZowJ71+kgS51
KqfiB9/2s3gEJSmaoxG4y8o7HiKxeb6RPTE+p/32pGLHJLZ9oCLt1PbFPUuqVe7Y
0akonuM9vlpcLjTlmzf4T41vVax5pIxEiFlSbM1CDEavSU9MJEkKc3cg7cUlzjKQ
AGTj6K1nxBDyRpBVXtFBZkZAmdyz0wA+VSAO7PHDXe5NfeVPkCBIL2fQ5GjctmZb
rK9yQ12A4ByfNVz3Zl2Pn0cU4+IkyAIX4iRImNl1XjvwOkLgxASpGOQ+wscwA2ML
pYao6V2kaUlkXLKc3eyTwbwn2awXCiqIi02WxXm4xJFhF+7PK1PzX0U1EyCgLbAK
t25IR62mBubVaRqjGLELgtpCovfFeYupEIJAS3g91VXa1DWUo7jTwDjCAKzDu1mf
SDW/szIA3lvklUAsiHxtmtBKUfuJXT4en5fusMwfLIj1bPn5LpZD/xlL/ayGiNf8
eLo9MDqe6rUL6lDBLgMG
=hMq7
-----END PGP SIGNATURE-----

--=-bJvfEdoDR2BbDHv1b4m+--

