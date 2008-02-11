Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYBKMWP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 07:22:15 -0500
Subject: Re: [PATCH 07/13] o11s: support for mesh interfaces in mac80211
	data path
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1202523481.7025.76.camel@localhost> (sfid-20080209_021706_077069_B7E22ACD)
References: <47a78281.03b48c0a.7362.5d39@mx.google.com>
	 (sfid-20080204_212421_865811_21908028)  <1202345620.9965.80.camel@johannes.berg>
	 <1202523481.7025.76.camel@localhost> (sfid-20080209_021706_077069_B7E22ACD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y9F9Dzt/RKwN1oTiRL6y"
Date: Mon, 11 Feb 2008 08:50:15 +0100
Message-Id: <1202716215.11481.8.camel@johannes.berg> (sfid-20080211_122219_263641_E3486311)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y9F9Dzt/RKwN1oTiRL6y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > It'd be shorter to write
> >=20
> > 	if (rx->fc ^ (IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS))
> >=20
> > but I'm not sure that's easier to understand ;)
>=20
> Would that work? For data frames rx->fc is 0xYY08 (with YY being the
> flags, including fromDS/toDS), so they would always evaluate to true in
> that if, regardless of the flags.

Hah, you're right, sorry.

johannes

--=-Y9F9Dzt/RKwN1oTiRL6y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6/+NqVg1VMiehFYAQKimw//cREeha/k0uZMP57pBooUtkVak9SYL4u9
ul51m254rVj7b7snY726ZJtPEiK+c0y+GO46cqW7pqTynYhw9W0rQ1ZAo5jcIEkG
Be2nGP+sU6UnGkhzpYStx8NqEDZa0P9q1k54MsNw+AL6iFXKc1+c2954Vytq0RX0
R/9KUR5D/TQ1ltJ3DzXRwBDJK3++HFZ2Fg3RTMKJkxYF831Jhi4fD4Sx8lQMwLK4
eKbciNMRcjeM6Igm1OQHzVtq8Uvxtt4VOPLQmuS5TQf85F2G0t8PS0NCV7v0dOh/
TJtXJoTv4/LAUwYjkOr8NBI4tOqc7nd4UCJCQxC0kv0Hq5oGCf8R3cTKtTHgup+A
yLCfCbGzIRAPzueNhj42X7xVi1aWddkwyd8EMkDkR6KJZRo6BptY5qCoVwlrSgvL
jYt5esaiE3NBd2MgyC1LXqY3StDRus8zg+s4MshWJvSkohmIW9cAxr6j2xAX1rPA
nb25k8IF+pchJbDTgSeZYIKH2+cpamdspNA/WTIUKVIBHBBRDX9xAZ082v2aeYo+
e91/T7+Hf66JrbFvyWwkF03rMANsWwXrca7OEsyl8rh4mbyYRSTRycvve2TZAy8Z
PXZtKC4s3oaBQXlyrHXSmJRUqgDEA+3Z5xHQdrQSDoj4l0Y5CMfL8hQdr4GZOS37
EPFACzHyG9E=
=YTg0
-----END PGP SIGNATURE-----

--=-Y9F9Dzt/RKwN1oTiRL6y--

