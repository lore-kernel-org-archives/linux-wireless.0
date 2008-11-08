Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbYKHLBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 06:01:24 -0500
Subject: Re: problems with ath5k driver.
From: Johannes Berg <johannes@sipsolutions.net>
To: msan <msan@email.it>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <gf3rag$l51$1@ger.gmane.org> (sfid-20081108_115741_111995_B4A89A2F)
References: <geiib4$apo$2@ger.gmane.org>
	 <20081103191625.4rwqio60gsgs0gso-cebfxv@webmail.spamcop.net>
	 <get27e$ka2$1@ger.gmane.org>
	 <43e72e890811051322m43efbf03gd21770be382e807d@mail.gmail.com>
	 <1225989658.4276.4.camel@dv>  <gf3rag$l51$1@ger.gmane.org>
	 (sfid-20081108_115741_111995_B4A89A2F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NymYBO7SCbRRyWMfJYpB"
Date: Sat, 08 Nov 2008 12:01:25 +0100
Message-Id: <1226142085.3610.4.camel@johannes.berg> (sfid-20081108_120127_620686_7578A1A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NymYBO7SCbRRyWMfJYpB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-08 at 10:57 +0000, msan wrote:
> Il Thu, 06 Nov 2008 11:40:58 -0500, Pavel Roskin ha scritto:
>=20
> > Actually, I tested AR5007EG with Linux 2.6.27 and it worked, even with
> > WPA.  So the problem is probably elsewhere (bad antenna, lack of APs
> > around, curly hands, irrational fear of things "under development" etc)=
.
> >=20
>=20
> If I can say, the card now works perfectly but is rather slow.
> I am downloading some files from another computer inside my lan at home,=20
> not from internet.
> The other computer is connected with an ethernet card while my computer=20
> is connected with my wireless card, ATheros.
> The download starts at 1Mb and more but quickly degrades at 200 - 170 kb.=
=20
> it.
> Perhaps the driver needs some work yet.

Which RC algorithm are you using? Use minstrel if you can.

johannes

--=-NymYBO7SCbRRyWMfJYpB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFXGCAAoJEKVg1VMiehFYE0UQALyRsgLu5AFqv9nGGbBHu92D
vKoZBSoGrZq8H55kWWa+B1gak4aY7V/KABnRzFjBgwnhr6lZ1AtkVbpmvk7OedoG
fellKTdP9UsxC+4nYhBXAL56pC9GAUqMFuPeTBL18JnsYodGFqzUJ5+2zGYS3VKm
2XQhy1MPl6Z2/1lA02cR5d6IdRxiUa/SYmaTH1GFEsPZbrKPSPy5yJUjbqm2t6g0
ww3ojFOLRDlcFY4hgKZ7jdZNZFi4RWIPxMmgikMgv/0/KnPSQeFdETwCsR0rCSGh
c1WDUPD2u9JBv6Sa9HtehVgJ507LqKJwD0x6EZsIm57oLzXFdS5l48bN6finPhRz
t/g8ayQTdblIMW6LFeSkm5vthGotHzJAc9Rvuag3EtLtOWaFbJGuBa88MSAPIk82
8IHyZiSts3BN2XCaTd7cuCNRSgkkpnXs1Djg4OiZUMUUGX6YGrmm96ZwqAMp+yNv
cb9Va/ObKDmDDTtyuOWxOjZRs+2i1kzRxfd41SXwmK2nLzZmIK9VA9ltsr97tq+u
t6RuXGTw94YUAlTpF3zEVvZpWC6MjyaJaDo2bEsxq2n1bSzve7tbVP25cfCaa9dG
Vil/NeVafD0NVkOLF5FlF/y0yJ1Ib0aeIsUnnNWsWz7n/VDhcQYj1g+LxUShWJJj
JbMt8siP4Nf58N6pXxxm
=f78q
-----END PGP SIGNATURE-----

--=-NymYBO7SCbRRyWMfJYpB--

