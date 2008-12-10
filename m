Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57743 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbYLJJGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 04:06:34 -0500
Subject: Re: [PATCH 1/2] Add signal strength and bandwith to nl80211station
	info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <rogge@fgan.de>
Cc: Henning Rogge <hrogge@googlemail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812100753.58590.rogge@fgan.de>
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812092050.29545.hrogge@googlemail.com>
	 <1228857372.1029.25.camel@johannes.berg> <200812100753.58590.rogge@fgan.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PlwBvGtxEjFRAgp2xX21"
Date: Wed, 10 Dec 2008 10:05:50 +0100
Message-Id: <1228899950.1029.33.camel@johannes.berg> (sfid-20081210_100638_184114_208757C9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PlwBvGtxEjFRAgp2xX21
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 07:53 +0100, Henning Rogge wrote:
> Am Tuesday 09 December 2008 22:16:12 schrieb Johannes Berg:
> > No, that's the thing, for 32 through 76 the calculated values are
> > totally wrong, that isn't a logical extension of the scheme, MCS 73 for
> > 20 MHz for example is:
> >
> > four streams, using 64-qam, 64-qam, 16-qam, qpsk with a coding rate of
> > 3/4 for a net bitrate of 195.0 MBits
>=20
> Maybe you can just post the whole mcs 32-76 table, so I can look at it. I=
 can=20
> only work with the values in the wiki, and at the moment the calculation=20
> matchs them very well.

Uh huh, it's a huge table, and very irregular. Not very inclined to copy
that right now. What's wrong with deferring it until somebody actually
implements these rates?

johannes

--=-PlwBvGtxEjFRAgp2xX21
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJP4ZqAAoJEKVg1VMiehFYdIEQAI85aQU3c4x9S4y9EIJNSMWC
ifDhnLGfVaIKrn3H/cFjlw6gciWV1M02gld5JogCFfFVg9HfsgVQHu30LcFFsW8T
99T22HeYwWm0uTrUG/tXHo+VJvfV+AzZxdLQyAUt/mVxZ5NbAJbl25K7SqS8kP4k
MBe0XSAvzvg0NtEONELJj5j8n4H/hf9my+scebqihM+wuZKZgHm5m08Wot8QQCUi
NRO/NIBMU3HU6gUAxHG8GjKjdtcLQmXKtHaJUoWrqoO81ZZIRtYL+1nm6pffw1oB
XcBYoQlaI4Zn7OF7uWjYByLbVMWftNwZEZxkQvH++VGzcPDgo9CIoV0illiO4xNa
zZugVZBdwQKIAukDYd6eEU2oeiILYz7TxuF6Q7IWhkq/B6OEg30NID8PCx5HD6JF
4JkOq/t+Abq/9gt7+0G8jaztI6kr8EGc8ItTFTqMON9qkUDBK9J+xfQ4cByzIXc3
uxlmumU/F/pCG3w0+sy1DjhdeEzwDQtEftGuDkLRtFszUSCRICxcQ+MS4bI6Msjh
vdTyRTZ84kO/DLw2r6eSZbZxcijfC0Y/gGL0bTim65YJ7BJm48ndLbD1oLF8bPZ2
qnCbPjqg2ImMOwM38EX0rketjVDZwZ2AwgH2rqFNam1u/37gWhYO6ff3cTs3vsUT
OCkJ70LQ03ODN5uLjv/1
=GLMU
-----END PGP SIGNATURE-----

--=-PlwBvGtxEjFRAgp2xX21--

