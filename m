Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbYISN4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 09:56:36 -0400
Subject: Re: ACK matching [was: TX status reporting with help of an ack
	queue]
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>, dsd@gentoo.org,
	kune@deine-taler.de
In-Reply-To: <1221832302.4514.6.camel@localhost> (sfid-20080919_155215_459241_3CF3BD6F)
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <1221505251.4511.77.camel@localhost>
	 <1221541089.14102.44.camel@virkkmi-linux>
	 <200809162018.42576.IvDoorn@gmail.com>  <1221770220.4563.3.camel@localhost>
	 <1221776990.4563.19.camel@localhost>
	 <1221815294.19539.15.camel@virkkmi-linux>
	 <1221817584.4491.29.camel@localhost>
	 (sfid-20080919_114701_416600_478C4255)  <1221818057.10419.58.camel@johannes.berg>
	 <1221819579.4491.34.camel@localhost>
	 (sfid-20080919_122011_765612_F53F8EFC)  <1221820265.10419.78.camel@johannes.berg>
	 <1221832302.4514.6.camel@localhost> (sfid-20080919_155215_459241_3CF3BD6F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mclMJJ/FzHlRIHGrIBnZ"
Date: Fri, 19 Sep 2008 15:55:47 +0200
Message-Id: <1221832547.12059.14.camel@johannes.berg> (sfid-20080919_155639_964161_BBA99161)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mclMJJ/FzHlRIHGrIBnZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-19 at 15:51 +0200, Mattias Nissler wrote:

> Well, I understand that we need synchronization of the state machines,
> maybe we can advance optimistically and detect in the next state that
> the STA didn't receive the last message? Just some random thoughts, I
> see it'll at least be tricky, I just wanted your opinion on whether you
> see a chance :-) As I said, I'll look into it when I find some time.

To be honest, I'm not familiar enough with it to be able to answer that
question. I know it's currently needed and I vaguely remember seeing and
discussing that it's pretty important (and the stuff I already wrote),
but that's about it.

> > However, I do think that if the hardware just isn't up to the job you
> > should probably buy new hardware, after all, it's dirt cheap. :)
>=20
> I totally agree with you. I'm just curious to see whether there is a
> chance to help our users. I'm perfectly fine if it turns out there is no
> chance to do it properly, and I'll rather accept that fact instead of
> trying to introduce workarounds that are known to be incorrect. The sad
> thing is that if we controlled the firmware, we could probably arrange
> to have the necessary information passed to the driver.

Indeed; at least for those cards where there is firmware. But I guess
you always only get as much out of the hardware as the vendor wants you
to, rt61pci for example doesn't report frame timestamps so it's fairly
useless for monitoring.

johannes

--=-mclMJJ/FzHlRIHGrIBnZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI069gAAoJEKVg1VMiehFYGFwP/A+bHwFDNypr8eY5r+1fAWLF
0mqwm0J2uVCwRfUEOsdWs5zkB66h0nGAXQYSzKq5p8Gmr/UtByMxyjq6OihDAJFt
B1HLYTw3lA7vO/nyng6hBu77ywlBy0Lun8CQFcq1BFsyrq/ZXKQIxnjXZyr41NWV
+TJw8xL3+6s76YGLbPeYc+DTwXxnmIv2WIB6wUVbGtMjjjObyqFBMV/lhnAJMP7Z
fSvVQ4Bl3uzDRbUMpwhOwCV7ldF4rCTYUVGPqI2z01kUfmZGa7q/vv4+x3XIHYr4
A8x3rcynuCMxcYMlomDNZaGJtFjlQZc5ns6ct7nSWQ+pJkgo6O7C+N/pXyUG0TeK
oXLXnC04xtCp5OiixkO1abO9mc/wenGSJdIzdV1wQSSylnGB87X0Ll5P40XNaMDh
BHEn5Cf7K+MSgWJ0cUABAGK5jtTq2evLfiCU4H4NLcSiXz7IFObOIyo6jbNZDUix
QiYKuyoV8zrJ/asSd+l6oDlCqLPrIRgaBW1BqpkTaoO2Ctaac2XG0yDlwoTb+o6v
tgbi+BWtTEqqR3yMptZh2gxpfLY2ykcZf76Shvl04y8VRu+G7xBacMpkvor/YASR
TGfHot7H3JN+IYuviJtubvZ8It/Fw6n8A4zy5CC0Gj57fHwjSbQQZppXYNrBAztp
L7T9SDKvlBtN6mff988g
=NYDY
-----END PGP SIGNATURE-----

--=-mclMJJ/FzHlRIHGrIBnZ--

