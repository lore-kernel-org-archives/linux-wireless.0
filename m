Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56015 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbYE2IJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:09:09 -0400
Subject: Re: question about ...: wrong count at exit"
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200805291005.58611.hs4233@mail.mn-solutions.de>
References: <200805290937.22146.hs4233@mail.mn-solutions.de>
	 <1212047361.16917.6.camel@johannes.berg>
	 <200805291005.58611.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xfZlgTDMXo0zOrzdDzIh"
Date: Thu, 29 May 2008 10:07:54 +0200
Message-Id: <1212048474.16917.9.camel@johannes.berg> (sfid-20080529_100924_136950_10971F24)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xfZlgTDMXo0zOrzdDzIh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-29 at 10:05 +0200, Holger Schurig wrote:
> Okay, reverted back to sparse 0.4.1

Mind you, the problem with that is that it will not flag

spin_lock(&a);
rcu_read_unlock();

as a bug. Which was the whole reason I hacked on sparse.

johannes

--=-xfZlgTDMXo0zOrzdDzIh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD5kWaVg1VMiehFYAQLhQw/8DNSu2UZsLv2xEht2B8YbTDGf5TnpsDH1
56ANMNftyHtO369jALOpVb6Nocmaa8uUxxsEsWWAdnkfQ/CQDB6bYa8Yd1EjTihP
iyxHBZVeHxBSYpSDd1EtOpriP77LVNDe0inif3TY4RkIk5epEMuQShj5hMYrjLvU
aroQEE9Tnfdq3H/O5VA2T3mQoGDmVSSAyavlsJO10psbhTyq4ql0Ow3SIHPPwoA6
tdlLOR7RwvCst0gBFGB7ImoUVU/dwnXsQCF3vnEsXJXBsy8ByJAxvTOh7NitSdBS
VJN1S3ZOGpsratYiVWU/nWyvkIViJXW6h3Q/iRaNJUOCtdRJcuNIW7PZiQMzR93F
2UT826WLCyTNoLjadJ3sSUQmsM9W18JQ3OumiA+LgoMmJRrMwOF4VnsTFeDvcZVj
FhqQJ6O6qfWpdePGUBq2uLBdAkm0Tix1Umoltuyq0iwhp4sSHdwTmYYtKaWXIHFw
uKVY/mlzG27jmv+OR2fn67uzi1Phod++GUsrw/8MCzuWqbHb4eMQBd3BTVCznTSf
dvakiZj9ZhtqqsyQGxl4LxS9p2X2qCJ5W+WKQYwMfSL7dlZGEsiaOtVh+8IJmu6E
G3rYEOsvIOKmDSRi0qpvHs/vd2MAA6kS1fD7LNqZ0jVtsxf+99gM/lUbC9xwmnln
bKArgU62uto=
=Crs5
-----END PGP SIGNATURE-----

--=-xfZlgTDMXo0zOrzdDzIh--

