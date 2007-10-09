Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54517 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbXJIRFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 13:05:48 -0400
Subject: Re: Mode selection in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Mike Kershaw <dragorn@kismetwireless.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071009135538.GA29748@drd1813.lan>
References: <200710052319.10600.linux@baker-net.org.uk>
	 <1191837339.4063.25.camel@johannes.berg>
	 <20071008143207.GB7430@drd1813.lan>
	 <1191921702.4013.15.camel@johannes.berg>
	 <20071009135538.GA29748@drd1813.lan>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-peINh5DeHSK6KA7rWHew"
Date: Tue, 09 Oct 2007 19:06:15 +0200
Message-Id: <1191949575.4013.36.camel@johannes.berg> (sfid-20071009_180552_729591_E51A3B92)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-peINh5DeHSK6KA7rWHew
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-09 at 09:55 -0400, Mike Kershaw wrote:

> > Actually, what you're advocating sounds like "please let me restrict th=
e
> > bitrates to use" rather than "please lock me to a mode". And we need
> > that functionality anyway for AP mode.
>=20
> Not quite, I've had situations where 9mbit at OFDM (11g) performed=20
> differently than 11mbit at CCK (11b) for whatever reason.  I'm also
> fairly sure several cards (I want to say Intel 2200?) limit the max tx
> power differently depending on the encoding type (100mW for 11b vs.
> something less I don't remember off hand for 11g).

Aha, but I'm not saying that you should be able to set a strict bitrate
limit but rather enable/disable each bitrate by itself.

johannes

--=-peINh5DeHSK6KA7rWHew
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwu1BqVg1VMiehFYAQIYEQ//e72j+UwrGdueyWv80qu4ZjPY0Gai6Wg9
6U8IZnj+YPQP50lWSJEEv3oWXw9qbz5Ox0viT2GvCTd+5MAvDC6YD18Q3qRPVEBB
9mlklKRA8s2Oj0H6knX0f/DObEgIR5j3DFQvOu+p9owLCovYr0JiVLu06EoSFjcR
31i2ivuW0cArXd/caT4VneTOGVhz40ukEm14HcEPM3dQprbqFQK3rMC21pa/HwHa
Mxu5UCEKwXoMPZHhxdOgDrXc/DQHCY1UhC+J+93WvCC2g9Wck01qUlhrE0AxuUlq
jMBm+wpMMAemzy7uP7+cbkDcbRcX7Kw2BSOCfBsKRwHYuAZnd6Gd5VIs/rIqmFsq
kvv6xbbQHmigEnCgsYaMpiny8sEX/VfgNQYc70Rx3B+54nkjxicLm01v/LIsS79Y
EfInIvJbsCFOrWGqtPmssJWUmTKagzKqdkkxX3A9K9fqWv8Y1XT785S6yca50g3V
62UFFUgjIhsLKlSQMpwDLoV9kK2gscc8W4FtRigNdLKI0i1BvE8bifv2F2/dDurY
X2/yx8HE9ehDhmPB+VIjrfvsijqKPPFJp/vDinsIjHkqffMwKv07dRR1RhD47yG6
ZsIpeGoNX5AjkKjuVJgtVJMLqoEV0ST7bRXrxnm3rd7+CcV+0Y6+Q01xSuAh9cmj
TRZ4c5A8UMM=
=Dum0
-----END PGP SIGNATURE-----

--=-peINh5DeHSK6KA7rWHew--

