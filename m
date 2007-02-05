Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933480AbXBEVlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 16:41:45 -0500
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <20070205214333.4e77948e@griffin.suse.cz>
References: <200702041344.19117.mb@bu3sch.de>
	 <20070205214333.4e77948e@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+Ic6Knv6d2hrFPreDk+P"
Date: Mon, 05 Feb 2007 22:38:16 +0100
Message-Id: <1170711496.30959.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+Ic6Knv6d2hrFPreDk+P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-05 at 21:43 +0100, Jiri Benc wrote:

> What if the key is changed by the user space? You won't know that and
> won't call the library function then. I think it needs to be designed
> in the opposite way - the stack will call a driver's callback.
>=20
> Or am I missing something?

Wouldn't you have to reset the TSC to zero in that case?

johannes

--=-+Ic6Knv6d2hrFPreDk+P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFx6PI/ETPhpq3jKURAjkfAJ4tqM7Z9gnxPrEz+qRsHf0CeB9GDgCggrTQ
xaKpInpSuWwIxohnVD6+PMk=
=TJjX
-----END PGP SIGNATURE-----

--=-+Ic6Knv6d2hrFPreDk+P--

