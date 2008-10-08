Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41711 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbYJHIpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 04:45:03 -0400
Subject: Re: mac80211 and IEEE80211_CONF_SHORT_SLOT_TIME
From: Johannes Berg <johannes@sipsolutions.net>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chr <chunkeey@web.de>, Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>
In-Reply-To: <200810072214.13206.herton@mandriva.com.br>
References: <1223370325.3778.69.camel@johannes.berg>
	 <200810072214.13206.herton@mandriva.com.br>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hJQrzNE2jlxdoaFd/a9p"
Date: Wed, 08 Oct 2008 10:44:59 +0200
Message-Id: <1223455499.3618.40.camel@johannes.berg> (sfid-20081008_104510_155643_EA105E8F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hJQrzNE2jlxdoaFd/a9p
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 22:14 -0300, Herton Ronaldo Krzesinski wrote:

> About 8187 and 8187b, I think the changes below may handle it, I have yet=
 to=20
> test them, just posting to have some feedback in case there is something=20
> missing or wrong. I'll try to review the other things too (like=20
> use_short_preamble warned in the other thread):

Looks ok to me, except for the stuff you yourself pointed out.


> The values used for SLOT etc. are kept for 8187, for 8187b I got the valu=
es=20
> from realtek GPL driver (nothing is specified in the datasheet).

They seem to be very close to just the spec values in usecs, so maybe
double-check 802.11-2007, I don't know the values off the top of my
head.

johannes

--=-hJQrzNE2jlxdoaFd/a9p
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7HMHAAoJEKVg1VMiehFYTZwP/jhBwqIcqAWXJnBORbZzh7DC
KQvDlM1L/fyE0Zb5p4foceKjyeMLFdH7etRXwq8CsVMEceBkHkCvAHPFzflTdU+r
qfttFUk5dUVLryQr6GPsX19MspBlfCEYnvmb/QUttMQKX7pIsHkPWeHFxDkKiIFM
U4mqa4SrpasePk092RsvPMqjR6dyxFNj+qLrgIRCu8Wwo62X3hx4fCAzR6bsoHXu
fCLVL2k7mquK0GC1/CuC3rMJPdTlFOPk6nPtwCNCUVCjPM3DdxPdyegsNV7fe7ap
hSQ8CPixTkga8U82sj2ZPk5POkUd5Yssbq9e3kOSkdfGSMmT27csk46FY0YoXV/c
dwZxEv7C/1SRJh8QtCW2yQd3FXOsPuOeY8x+JJHBx6+eqj3NfQHd3Nl1mlQykbJX
aM7UT+A2yBWnBT1cGU0gBfy8Q7yzlqoFFVCtbzkBjw7/iIs0J+5OevDxnGUxzroQ
xy65Ojxuq9w4M5d8pZFW+n8bfPJxDDKXfBfAVaTgc6goJYRFye7IZXQeu83hwctP
zO+TNY/14TZlLygzbq0IX0V/nJlzVRWRTbhZwEBnAqd9qADN6GHrpbZRaz2YxU7C
hmqWcjSLhkRJGE9YBpau0zwPeUH660QpxHlGsnDLXqbC1C71pnRV1gKm4yYzGDiK
x7ooSXW6i61YCRbDQoCd
=8LEE
-----END PGP SIGNATURE-----

--=-hJQrzNE2jlxdoaFd/a9p--

