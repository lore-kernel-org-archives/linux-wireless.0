Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbYDAMVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 08:21:39 -0400
Subject: Re: [PATCH] cfg80211: add EU regulatory domain
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Morrison <bdm@fenrir.org.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080331230030.18da1c21@peterson.fenrir.org.uk> (sfid-20080401_000538_531462_F55C8CDE)
References: <1206997315-15878-1-git-send-email-linville@tuxdriver.com>
	 <20080331230030.18da1c21@peterson.fenrir.org.uk>
	 (sfid-20080401_000538_531462_F55C8CDE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NYrN9mGBnaMVm8G+bX6G"
Date: Tue, 01 Apr 2008 14:21:19 +0200
Message-Id: <1207052479.5143.68.camel@johannes.berg> (sfid-20080401_132150_028542_35B3DAE3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NYrN9mGBnaMVm8G+bX6G
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Is this worth having?  I'm surprised no one has asked for it until
> > recently...
> >=20
> > Are these values correct?  Including the power and gain values?
> Does
> > anyone know have a link to an authoritative source?

> +	RANGE_PWR(2412, 2472, 20, 0, 0),
>=20
> The power limit is supposed to be +20dBm in the EU, and it's EIRP so
> that includes antenna gain which I've set to 0dB.
>=20
> For an authoritative document you need http://www.etsi.org but their
> site is down just now, so I can't find the document I want.

Mind you, I think France and some other countries still have different
limits/restrictions, isn't ETSI just a sort of advisory body?

johannes

--=-NYrN9mGBnaMVm8G+bX6G
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/IovaVg1VMiehFYAQJiQBAAkwuqSTUk1OrL29Rch6s5AX915FoyUCh3
7aZNVs7JNrCzTkjK0gNsLKS6Rvn92o9qNGRyj/A+HnYWGrsyKZv7vO534vVvUfrJ
CNa7nS0aZnuFIpY1UD3l2vTORuTK/z3DqFDqtWjROkfsyEXG2Gh5xUVH3Y5xe3Ed
xlho3Y25OMzYnmVZXmtd9dsNUfoTww9gP1ZNXnw55GT/Hj+mQpS0PISd8onkqNGG
1IFFpzVzqr734Z813JJMr1Co/aiU2EIVFRk2sZUhTGFfYDVSzoywsgL9RI0RC8xS
xdrQFQNXaENPJstOGT5hobZO4cDS3onCDzSPtd8MDOPmjRoJV83mCHDnI5G87arD
D4nGspUASE4xdCHny3s1NsIp0zpMiE7u45zu/ldCb8LezVhN8mA50xuueNMvUQXB
+SJccYQeslMkPePgRHx5nrQeK9nB9fYT43Z9ScmO8G/9VX9nfJ31QuqNm3Em5/Ao
RrAR8Z1lLktrzjaEx7PKDRVUFvupwZXYOZ91Hli9YQsokpKNx0vmojaWAqRMqBPs
tu6XLdy398zutHcAvRMJ8Z1eCLxdbKqRvkNLEuCf2h6dx+RYZublpMH4tL3FkzfX
wQd8dKhU6yjEpTCZQkbzguXsrFvElmZL8lVyb3Bi80ZTY8z0XJiBtBW1u9zAXd9l
ViKfmbM1Azk=
=zEdJ
-----END PGP SIGNATURE-----

--=-NYrN9mGBnaMVm8G+bX6G--

