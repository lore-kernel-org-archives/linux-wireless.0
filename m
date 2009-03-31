Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbZCaILt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 04:11:49 -0400
Subject: Re: [RFC/RFT v2] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1238486577.5970.70.camel@johannes.local> (sfid-20090331_100348_648902_122ACD64)
References: <1238349195.24972.5.camel@johannes.local>
	 (sfid-20090329_195345_745378_2F2074B3) <1238451390.5970.59.camel@johannes.local>
	 <49D153C2.7010706@lwfinger.net>  <1238486577.5970.70.camel@johannes.local>
	 (sfid-20090331_100348_648902_122ACD64)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GpGIBmB87nVJ3R2DMt0J"
Date: Tue, 31 Mar 2009 10:11:15 +0200
Message-Id: <1238487075.5970.74.camel@johannes.local> (sfid-20090331_101157_671245_A0CC6D14)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GpGIBmB87nVJ3R2DMt0J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[dropping CCs, this is relevant to b43legacy only]

On Tue, 2009-03-31 at 10:02 +0200, Johannes Berg wrote:

> > (2) The radio LED is on no matter the state of the switch.
>=20
> That's strange. I'll take a look.

Hmm, has that really worked before? I'd be surprised if it has -- the
radio LED seems to be tied to mac80211's radio LED trigger, not the
rfkill LED trigger, and mac80211 knows nothing about rfkill at this
point (which I'll fix too, eventually).

johannes

--=-GpGIBmB87nVJ3R2DMt0J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0dAbAAoJEKVg1VMiehFY1JsP/2Hd1mq54WlNGUSKWEqKwJ/S
fkBv0cmhD5vSv6C+vbbmQHOl16aQZ5UekWyWWz2knYKGcwr/9dD15hdnfxU/NJrR
cX4elT6d4mAKs29rQnH0VsmmF/JN72iKPCPI2fI7k5wZY9B7k2ryrHy3OaZwmhNc
Q/I2DSOlaO0iiDjH3Xsf5MOhC9btg5uxxVG6WFeIbXbLfLVzHKVq6xc9idkFDpZl
eZ5unf13UXWtCsbabcru4MKdH9XcK+vy7lPV02bTstFBwRvhVq2X72awvmX0WqV8
AjVWR1mgdkAoDb0aZS/g7qUQ/nze230Y9STL3eD15UawT08F090KY9sssAXeE8eT
9vt5cpax+KvqmoVv191FrXCpy0N61/iF5qe6x3iUI/roW8uE6S7AKwPZTrfCZej4
GNatPdF4WN+GG/wFIkHgRnee1yMFM+dLgfdeOKoI9Oj3ZMOd28XuEGaEcO2SVoYr
T+/I34qq9fGtuKWUIj3//dgJqBWhPI3nVUQMYUF7drzOsQqSVEsjCqHB20wkBjGi
SkAqw7BQAhKs9ZDA+AcSymtSf6mgrGpwiZZGIQnvvX4tm8YPK3XJ/omuoHUTwzA7
mJRON+F+r9Sx72pCuv7seEIBJe3JHYjeVG+rS9mw3d69vBCp6d53fQgkKacY1rM5
iu6SMieXkGN/XhCrQqSs
=5Hzs
-----END PGP SIGNATURE-----

--=-GpGIBmB87nVJ3R2DMt0J--

