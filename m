Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43494 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbZGJQdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 12:33:08 -0400
Subject: Re: [PATCH] cfg80211: don't look at wdev->ssid for giwessid
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1247243482.2877.14.camel@mj>
References: <1247241214.29747.5.camel@johannes.local>
	 <1247243482.2877.14.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EeN3wx9Sa9fbiWsrPCbw"
Date: Fri, 10 Jul 2009 18:32:59 +0200
Message-Id: <1247243579.29747.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EeN3wx9Sa9fbiWsrPCbw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-10 at 12:31 -0400, Pavel Roskin wrote:
> On Fri, 2009-07-10 at 17:53 +0200, Johannes Berg wrote:
> > This variable is only used internally, _while_ connected.
> > If we use it, the sequence
> >=20
> > # iwconfig wlan1 essid foo
> > <connects>
> > # iwconfig wlan1 essid ""
> > <disconnects>
> > # iwconfig
>=20
> That was quick, thank you!  Indeed, it's possible to unset ESSID not and
> set it to another value.  But switching from "foo" to "bar" is still not
> working.

Dunno, switching is definitely working for me... And I can't see how the
code could _possibly_ fail.

johannes

--=-EeN3wx9Sa9fbiWsrPCbw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKV202AAoJEODzc/N7+Qmao5AP/0QHlzgxtVReYPMsGuqpJtkC
m4PWtnn2ijJZWOLsuV8ciKiH3dHNsM3NkRjsv1w1zlmgAoXP3P0ulJ/k8YXPfJZ/
kjpsGmmHLbu4/F/LYRsNvEURZ0lxffkUXvGBMyO6M7Db6hGtI2G6wp383SCF+2bF
oQ1eeslXYpYKsDx6vVJsoBzxRF4Sv+31pMryNzGpfX0iKtZeu6nDXqQrb85zS7kh
gU825cQblnjFVp9ak0gLhltsA/6yyeVsLKGrpOhBv2Qk8KHkVSuXm/b7CXQONMkX
r0uzFOb4zd9Q+qvU1xTYgicdYGJ7pOlXhtFE8ZGkl0HVNeTAhtSFwwUa0unM7R84
w+RfUe4ubnME7Rd3IhDvtsd8W52ZugZb3kNdE5XldTb06i3wEU1t4fOn357X8I2q
7qilxit9We9LJ0Mmt+MM4phE/+RAqjz/0Uwj8SEyE9Tc7KLIbM3amwRHEU9n82YE
SY4F9IUo8JTBYe5sWstKeD0qeShSCTQJEheWOwUzVBs6xmy+MOPNkMqjDLCEK0sJ
acnFZdZNKr6Pxlx1dg1jnPLbc9TFe5vhwXLmUYqgJcdRvnekU41K+6by2DWq8URj
UyYj4GSDCQgRdMPc1PIB9DVQUURGWW8KkJmBbVziMxhAccokgaVWOZviqk086zh9
FxM4+BfXvxL3nasz2zqL
=udOJ
-----END PGP SIGNATURE-----

--=-EeN3wx9Sa9fbiWsrPCbw--

