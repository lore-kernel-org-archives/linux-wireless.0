Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37408 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbYIXIf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 04:35:59 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1222242040.4183.1.camel@localhost> (sfid-20080924_094114_025986_BB83E1CF)
References: <200809151911.32834.IvDoorn@gmail.com>
	 <1221501417.4511.49.camel@localhost>
	 <1221501786.3700.68.camel@johannes.berg>
	 <1221505251.4511.77.camel@localhost>
	 <1221506496.3700.81.camel@johannes.berg>
	 <1221507551.4511.89.camel@localhost>
	 <1221507988.3700.84.camel@johannes.berg>
	 <1221510009.4511.99.camel@localhost>
	 <1221510785.3700.87.camel@johannes.berg>
	 <1221512487.4511.105.camel@localhost> <20080924005931.GB3780@tuxdriver.com>
	 <1222242040.4183.1.camel@localhost> (sfid-20080924_094114_025986_BB83E1CF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2DbeCRlkO6RAk8PNJ7bX"
Date: Wed, 24 Sep 2008 10:34:58 +0200
Message-Id: <1222245299.18015.60.camel@johannes.berg> (sfid-20080924_103603_103898_1E296CB2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2DbeCRlkO6RAk8PNJ7bX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-24 at 09:40 +0200, Mattias Nissler wrote:
> On Tue, 2008-09-23 at 20:59 -0400, John W. Linville wrote:
> > On Mon, Sep 15, 2008 at 11:01:27PM +0200, Mattias Nissler wrote:
> >=20
> > > Btw. lately I've been thinking about a new RC algo that simply
> > > calculates the throughput achievable by a specific rate (based on the
> > > estimated frame transmission failure ratio and transmission times) an=
d
> > > then selects the one that provides the best throughput. It's still a
> > > very vague idea, but I think it might be interesting to try.
> >=20
> > This sounds like a reasonable approach.  Isn't this more-or-less what
> > Minstrel does?
>=20
> I just checked Minstrel out. Seems quite like what I had in mind :-) Are
> there any efforts to port minstrel to mac80211?

nbd has been promising for ages, but has not had time so far. The full
minstrel will also require API changes between drivers/mac80211/RC.

johannes

--=-2DbeCRlkO6RAk8PNJ7bX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI2fuvAAoJEKVg1VMiehFYlI8P/jdVGnhdvVoSR/1eAHcKVGrb
puVasUrtk6F4AYX4RhXDMXpjh9H2m4ih35Qt9kVMW36U4hQPboytdfire0x0OwPi
9UvN4LL50oOvH5Z3sfifLPF4c29tPUY1ZjNwjtz8fnlDRQ26uAdBxAoEtO2CoIon
B0oRkd6Opv4+hjDQvON7JlGDnRZI1LcKXXcODMVAo2Yy7NzbK/wztoAHWUoTEU3g
Iijy+P8KTEMts0Yx9oy1WSCYSfQfz0L3Xveazr4C3L0LcbiTtEbq/2sb6rLsWeF7
iqvQKK6wmO9Rx6ll6zYOhbZTIicwntdVhMYYcaIRQ7xatIElDJ2i/MvvDY9n5GxJ
98jhEFewpRAGDxvN1QaQt/nSacps6Fc3w/XJ0RE4j8dNai9xDtin7VLGP8oyzwud
KyEplS7WVTRmb3SAeNo3c5lXMqgFek3XAeehTZyK4fhXUQ0In799PCq3qXmOH47u
h25vF9UPP/NpqAQWtrGr0ZHRvZmRlXHpPGoFSo7WncpKpxUr9Trn2/Z/HOrknahm
AnQyg1K7sdTxAMUo4r8g6dPgOnptfG9C+K8104Ed2TFw+Fpdivv+O+cB29yDsBnj
KhRNb30B/7lX9u6nTnMKwLqSrBA43bO/3RH9Mb/Mug8dAzgdKokbfLv3QhApH1q3
8AGdbGf8N9Gd88jD+tS1
=8yar
-----END PGP SIGNATURE-----

--=-2DbeCRlkO6RAk8PNJ7bX--

