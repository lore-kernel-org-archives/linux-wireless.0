Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38563 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbYLEJlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 04:41:03 -0500
Subject: Re: [RFC PATCH v4 1/5] mac80211: enable IEEE80211_CONF_PS only
	when associated
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87vdtzi36x.fsf@nokia.com>
References: <20081202200219.5507.83250.stgit@tikku>
	 <20081202200359.5507.40576.stgit@tikku>
	 <1228411658.5692.19.camel@johannes.berg>  <87vdtzi36x.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-q0ope27HEZCKf0Vy42I5"
Date: Fri, 05 Dec 2008 10:40:58 +0100
Message-Id: <1228470058.3970.6.camel@johannes.berg> (sfid-20081205_104108_936911_1198C954)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-q0ope27HEZCKf0Vy42I5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-05 at 07:47 +0200, Kalle Valo wrote:

> > In fact, it might make sense to check that there's no other
> > interface (except monitor) open?
>=20
> I'll add this check as well.

Actually, come to think of it, this doesn't make sense unless we also
add a check into the interface start() and then disable PS when another
interface was brought up, let's just leave it at "only on STA
interfaces" and if you manage to screw it up then tough luck.

johannes

--=-q0ope27HEZCKf0Vy42I5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJOPcmAAoJEKVg1VMiehFYEPYP/1oXb/2WLIrok5324d7AbyXV
5sI0AKS+At4eGry57XFY8tlqQhpV2r4UETGi5km4JMqVOu86N5h9fHAQXhDGXGNN
GjD5pBzHHJlrVKpjGGad7Dr1nQMVwZ/YYeWLrn5KD+DsW5bJ8BANbIl7mjT07onb
gqKntNQ/DI2Wa6v7R6eDnb4M985UkK24/cYJg2eBD4XVECebIuPO0dc/RNC1l+sm
NXPXHY8ukWr3KdJzzKP4paq6yHinnypRtGW74ziIUjtCkqxldocMh7m5Ex/LordT
RwS4aG78sdQGelTgNlTgq61Zbc0mt+AfxEGVVaYsLTGi3vw56fnKV31cn7wLSh3A
F2Pbs0uzhDRD3DIiHG7WTlXmofz9aU446NUpXFwATydo8pV9tOMq6kwW5ezQYO9B
m0i5fYE0grkpQbLC3JxbBum/xo40m4ivCQ+QNnzwz3FdgTLwQBu/AstBgtjJpPFW
tmsINKNB7cWeatpqbl5X6kqJVU2cx0QEfO/Tri3Ak/7SFpUGtzzDwUpkmnEEs6k4
4iTQv9FKa5cef6gGAVHkV+JKjlKGY56kYdUeoOQkhudqbccWxkTyXf9KDJUpSG7R
mLoxSA/mm1U50lS9PP2hAkpNITkkIf868JDHMZ+6aP4LplNfDoO6OuP3zSl5GQnZ
ODjyk1JCbZVRF1MtKjbK
=SuhM
-----END PGP SIGNATURE-----

--=-q0ope27HEZCKf0Vy42I5--

