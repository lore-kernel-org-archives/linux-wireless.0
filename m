Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54554 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811AbZAWWOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 17:14:06 -0500
Subject: Re: [PATCH] ath9k: Read and write the TSF via debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090123044421.270720@gmx.net> (sfid-20090123_054428_080982_2340614F)
References: <20090123044421.270720@gmx.net>
	 (sfid-20090123_054428_080982_2340614F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dSe76Edtp+37vFjmEaoI"
Date: Fri, 23 Jan 2009 23:14:01 +0100
Message-Id: <1232748841.3977.10.camel@johannes.local> (sfid-20090123_231411_600733_2F4D7F14)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dSe76Edtp+37vFjmEaoI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-23 at 05:44 +0100, Alina Friedrichsen wrote:
> This patch adds an ath9k specific entry to read, write and reset the
> TSF into the debugfs, like in ath5k. This makes debugging the IBSS
> handling of wifi drivers _much_ easier.

Ok, read I can understand, but write??

johannes

--=-dSe76Edtp+37vFjmEaoI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJekEmAAoJEKVg1VMiehFY0QQP/jIdkq8aUOvoe+IuDBBdZKf2
bqh2A221DtXW4fgkPZ/OfX6Ppuz6L/JR2cO/cx7xxmWlKAP2D6we8JKoGgV72e1U
yd44C9LsKQUxY8mLmTN/AZQzxVwHI1TBv7SxFnzMNGE5totfpUa/wWghoA+as/H5
hUtFsvsI8pf3N+9L6u456xBetAaOl+i+q807ns73fxp4hZKORpFIvYBMbrYVz/Wd
VeEw5AAcyHFyzMa/rJRgbG7R+851REhh2C5lPxvy0251F+nOeix4iEEmoffGzGaF
gjYyKAgP+SSU6/e9720f6roZ5Yg9+LX1pKIcBY9UphKMQn2Ff7ddSZ5mIU9/TZFl
njRWPeU6zA5bJ2p2VCAN8iU02xmUqiL24ZvIs5IHgfgjJnYsp8HZwfM6Kz7rnC13
RmtY2i8DxBtaokDCso6JRXb6qiX9hGzn+/M/jfVd4maXF/1mUKDzy+cQ6ne+n4X3
Ylhy5HXz4btpgksfKPmJ4CdDxWwUEYMsQQTw524mHiDhzm9OTRbB6JGoyzaYUrJD
KaqNliIxDuQrIP33fMDM4hAQyHb1lKdFLBuB9snOeMUYiuYLlPU+a2Kefhm8uhZP
HmXQhslWHNOux11YCC2RFsq1AeozdpMenekoJzFakrNk3QsAsX3nm837LQZ0B2hj
GYdl/INhrXtSCXxFrJSu
=iu6h
-----END PGP SIGNATURE-----

--=-dSe76Edtp+37vFjmEaoI--

