Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485AbZJaKDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 06:03:50 -0400
Subject: Re: ieee80211_tx_status: headroom too small
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Nikolai ZHUBR <zhubr@mail.ru>, linux-wireless@vger.kernel.org
In-Reply-To: <200910311044.45687.IvDoorn@gmail.com>
References: <1094614475.20091030230028@mail.ru>
	 <200910311030.45582.IvDoorn@gmail.com>
	 <1256981677.3555.94.camel@johannes.local>
	 <200910311044.45687.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1PGU5q91NAAJFBGQA5p4"
Date: Sat, 31 Oct 2009 11:03:52 +0100
Message-ID: <1256983432.3555.121.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1PGU5q91NAAJFBGQA5p4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-31 at 10:44 +0100, Ivo van Doorn wrote:

> > Or maybe we should just not bother with having drivers do the alignment
> > any more -- mac80211 does that now and it only does it if necessary
> > (i.e. not on powerpc/x86)
>=20
> I think you mean the RX alignment, while I am talking about the TX alignm=
ent.
> Beacons and some othe frames must be 4-byte alignment because the wirelel=
ess
> hardware requires it.

Oh, indeed, I got confused.

Hmm. TX alignment is weird ... no driver really needs that except rt2x00
afaik. Which frames require this?

johannes

--=-1PGU5q91NAAJFBGQA5p4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7AuFAAoJEODzc/N7+QmaSW0P/1r09T9lE2dGQWE3SdfRURRr
jLraSyOa3p0WcJVZCFzsxDHIvXhDKFOB7Xdcaoemg/PEGooGSpatiRibaxYLrGaf
FOhs6x9IaqfiOCZiYUEhxdp/5ZlKH84ojbeuDoLlOkVVHj29S1ZbMd5sEik+zuQX
yDF52VWuw1izqNrQ9fSbZV4Zz2+etB7BdKfRH2Hh2quV7amMlTqdSSJJG1sScMvX
qSbUD3pI9UvmrwS1ksu+AJU/0oWmH9FxptkiztM8BBg/aT6OC/+DYNurzoayutYI
ZQiS+Tk935oXDJt74CLU++g0Lb/jIp/jpjYKkH/eZLIRv+bRGdI+31YsR6Skmm+l
MKQThn5ABYGc3pKX9wApEVU52jM+5q4t6miwYRycQl4gwV5KrHCOifeXZQk/bFTZ
i/cFCnH5mBr6wKrQMN5QXSZp8uf4vvT98Keh2fUmdRca4B7EwXIHYeXfotNcYQRa
ox8HV1wc7rwgIGAaYayLW9Toqqp1KFWVpA2bMWM1rC/liEn5REepG9svW2mT8IkE
3zrOWf3zz+RomM9KPGNu7/JUYARxT0Rl0RzOEgIcRRjfNCyhFrUb+/gs0+uDp8m1
cPoH4kto2kjr27aaO1ruNIG8YEG+0xJZBlU0DRaeqmjF9Vw6Mvyo1+KVKO4LBtDR
jxap6ErQU626Fy39gXU6
=geCg
-----END PGP SIGNATURE-----

--=-1PGU5q91NAAJFBGQA5p4--

