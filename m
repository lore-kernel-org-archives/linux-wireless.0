Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35403 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbYIGNjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 09:39:33 -0400
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dJJPXxQ2O2S1Y6JMAXo1"
Date: Sun, 07 Sep 2008 15:39:25 +0200
Message-Id: <1220794765.31304.8.camel@johannes.berg> (sfid-20080907_153937_976752_6A38CE0A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dJJPXxQ2O2S1Y6JMAXo1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-07 at 01:14 +0300, Tomas Winkler wrote:
> This series should fix mac problems in disassociation
> There are two basic problems disassociation in current implementation.
> The order of steps in the dissociation flow and missing proper
> disassociation when moving from one AP to another.=20

Mind if I adopt this patch series? I've done only slight modifications
so far (the int->bool thing I asked for) and have rebased all the
patches I had already posted on top of it. The arguments to
ieee80211_set_disassoc are changing a lot in my patch series anyway so
I'll just work on top of the bool/bool thing and  then fix it up, ok?

johannes

--=-dJJPXxQ2O2S1Y6JMAXo1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIw9mKAAoJEKVg1VMiehFYcdYP/0e1H78FYAvHbpxFzKwDuHLq
bUbpcEo/NuogL+GNahznvPDB+9nMvMeEO5y5djiccAAvoWSOCmnIvS9YL3Ahz+TK
bFpz7ddl62LtjDoNJdoP8DmSK7qiF8Z+5/d65GD8ClEPT1qFMLqlrw0b9K0cz6RS
Dm8ftMaBaBPBqzA2uvK1Pg2XDBCcV4GimD/fE3kwpCx3Qt/qG3Yv/sqmDJYEA+8U
UAMG6WPF7gOcAzalvO8gvCD5cCwlc+fi914+K0S34ZqNzAnCnNdmEgc69mhzsX//
i2N9t4Jd/1BGkDnTZsVmJ/71Jc10pGRTD0YkmZFFF121Th0hZrh54wzFmQ1ADhUL
HmTkcZ2596hlInIjxW+WTexG5qOCMBZWrIQcXLHzEvlzTOazKkogimNesU2Y6TK6
hdE4wOjn2Vh3iZvBYyPLK5Hve4UBrAJ2213F1W61W2cFBTo06h9M9LKb8yxEwgb8
iBVFbAprmKnoWKYEawtlWLB/BPJ7NPOcezdsAk7a2HAn3sD2VQKQXlbml5RRihnP
Jlil5rwkpjr3JaDfw62eo7OjkfKNv2sLDe/zmz3zcyI3zCOoYnoQ1aq6o4ZRb9Lg
o5NkE7yB5FNmZaAGll/CFoRbKbLJN/A9LAmZjREwbUK87J+T606L2UHTw5XtKH/L
PWG58+iQ4gsbAkOrH0FP
=ONJa
-----END PGP SIGNATURE-----

--=-dJJPXxQ2O2S1Y6JMAXo1--

