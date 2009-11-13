Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41172 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZKMHbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 02:31:22 -0500
Subject: Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
 injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Matteo Croce <technoboy85@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <40101cc30911121418h4109d62bv763bed2036446901@mail.gmail.com>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
	 <40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
	 <20091112154440.GD19349@tux>
	 <43e72e890911120749n72360f0btfb058ab3a521eabb@mail.gmail.com>
	 <40101cc30911121118h17db32a1y61edac1a4c0aec24@mail.gmail.com>
	 <1258054304.3899.36.camel@johannes.local>
	 <40101cc30911121418h4109d62bv763bed2036446901@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PzXqbavtZQuA6IzXcvAm"
Date: Fri, 13 Nov 2009 08:31:25 +0100
Message-ID: <1258097485.3899.76.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PzXqbavtZQuA6IzXcvAm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-12 at 23:18 +0100, Matteo Croce wrote:

> kmalloc-64 is definitely getting fat

Is it the same with ath5k?

I don't see any allocations like that in mac80211.

johannes

--=-PzXqbavtZQuA6IzXcvAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK/QtIAAoJEODzc/N7+QmaOdEP/jvuSmOgFVrevQBfvJhK28Eu
VtkEimctmrd82VA1ZapHYLJCDI4exMORNkqy5mbwkwC4ZXMSfP/m+4a2uQTNxTQr
+CZxX/Lj2UF8z5e+wR0a3b8Uz7HKL42/yxepsdU9kIp9REM9HTmQzvvTEkhX88bO
UgjpYQEjk4TOreCTWMHqj5REhT8eqy4CkNKlSxNsUsnscW2dB0GqBOj+Mc2FVBke
9sMpKzlzLdK5zWVpV2/aIIkjU6djvdQ1+UYyXKTwUcX8nTBZ8YYa+M0x/T9B21MA
opGvUdhlyoG/jyduPzBmZF/B19il3WvkSQqErhm3ZobT2P2ZMkpkV7pR2vbwKTnu
gSrCAH8AjZAaIXAzuRpeFi1QfKECYMv5WsKzMZovfTAURN1/tIT33jhLfQoZ8tha
rVSwev0qiz7ert4RI50747qGPrhLl3eAU/tMblhAQBOpBT6KQRcun/fDr3ps7zA+
ruWhKwNC9zmIGNJapcH5nEsG1w0J/GA9knrgdizILRcImRWx8berDyPfDdQmlg28
8H15NW1U50J2wa8zwEOx3+Gt0bqw4StDsI8D6eV+szGO6Cw1z7cv6vu9q4fStd+1
VFvchVdmTulMOr5U7oyOWtyPqkWyz2LCQA2h2R2VN9X/FLd3gDq4H/KtNvo0K/DZ
lhPjr96tZTUzy+wfD+Lr
=X8xD
-----END PGP SIGNATURE-----

--=-PzXqbavtZQuA6IzXcvAm--

