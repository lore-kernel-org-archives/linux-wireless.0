Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52435 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZJWNkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 09:40:14 -0400
Subject: Re: [PATCH] cfg80211: allow driver to signal noise level
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200910220913.19759.hs4233@mail.mn-solutions.de>
References: <200910201413.29734.hs4233@mail.mn-solutions.de>
	 <1256080691.4475.8.camel@johannes.local>
	 <200910220913.19759.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JkU6jLYoTuN5BMDDt1rI"
Date: Fri, 23 Oct 2009 15:40:14 +0200
Message-Id: <1256305214.12174.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JkU6jLYoTuN5BMDDt1rI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-22 at 09:13 +0200, Holger Schurig wrote:
> On Wednesday 21 October 2009 01:18:11 Johannes Berg wrote:
> > As discussed previously, noise is not a property of a station.
>=20
> URL?

At the wireless summit in Berlin, I think. I realise that not everybody
can be there, but still:
http://wireless.kernel.org/en/developers/Summits/Berlin-2009/notes

>=20
> Should I aim for an "iw dev XXX show noise", e.g. try to
> handle it as a property of the card?  I could either add
> an .get_noise() to cfg80211_ops, or better an .get_card_status()
> with some bitmask of filled fields, like for the .get_station()
> call. What would you prefer?

It's really a property of the _channel_.

johannes

--=-JkU6jLYoTuN5BMDDt1rI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK4bI6AAoJEODzc/N7+Qma6UsP/jIxRrpt8lR7LeFgz3h/Wcnb
miRcE7SktOy7BWNgaoHHtFVwhZkDOxsZEqv0x511EBybxzieuwsim+k8bRF30BJt
NoLuXKVZeH/gwmUpXdaswlI7XzioCVEk7crEdLUtPXRbdmSceQ0VwVHtmCSbjcWA
ZWhoPyP9RJr5CVH8n37onfq+m0WbI0NzrrGsvb6QC7JnsMNdzQ2ee4T2jp/c7WWA
Pj+hYGoCyCTivpX5/S5oLQ1cluzhxIaAWOv5WkvZMC/LyAJU3f56VG5E+ET+Cna5
jRzJCqx3inweRGkQhCCwjMkVpmvNjHa+/FiHo3udRbNahaOnsqF8ckOLrBZsgotZ
N23JpmOpmPDxwGst7BSUOpIhHnbaYEWld9RnLhppF0Fk+Z/ITZJGmoaZkiH53txH
B52aQ/BGZkdogqFM9/ZmzXg45CrtAYuo/3iC9U3MlAn7FRL+ru+MQFUQ9Pw7ig+Q
YrCSbprmaQFLQjVkhOr1yyG4fH6Sp6PG5/LSLsYTSBFnSwvFptLhG9DLEMsd/xmA
EPUodySwYQ2ey5TCPzLQRsk/u5z90GOjukZKmXUSsuldbrEJnbAB+8ZXM+UyeqAC
mrGV0HVkkO8H0bVJ1vMtujKv5Xx7SCFLAFPB2b5Ag6mb86jPkRVm17lriCdKyeLR
ttPensniumhmsA9O5yep
=lqcd
-----END PGP SIGNATURE-----

--=-JkU6jLYoTuN5BMDDt1rI--

