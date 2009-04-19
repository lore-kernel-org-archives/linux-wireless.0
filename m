Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38643 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbZDSNRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 09:17:39 -0400
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090419125212.158800@gmx.net> (sfid-20090419_145246_566920_BF082D12)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240097845.25826.1.camel@johannes.local>
	 <20090419125212.158800@gmx.net> (sfid-20090419_145246_566920_BF082D12)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZFePMZZXyBKiquGeGYVi"
Date: Sun, 19 Apr 2009 15:17:29 +0200
Message-Id: <1240147050.25826.5.camel@johannes.local> (sfid-20090419_151746_096788_E03FC6ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZFePMZZXyBKiquGeGYVi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 14:52 +0200, Alina Friedrichsen wrote:
> Hello Johannes!
>=20
> > This adds IBSS API along with (preliminary) wext handlers.
> > The wext handlers can only do IBSS so you need to call them
> > from your own wext handlers if the mode is IBSS.
>=20
> Why make not assoc() and disassoc() to a generic mode independent
> call? Only the handling is deferent on each mode.

Because you don't associate with an IBSS? Trying to shoehorn that into
the same would be ....?

johannes

--=-ZFePMZZXyBKiquGeGYVi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6yRnAAoJEKVg1VMiehFYYuwP/R0gBlCDai+DLxPzeUopmknF
tEs4Y3i94Et+XIhBkvwqhjdofg2ycrQO/5LVMzbG1x94iPovHtAh92zhuoHdC1FA
G1N2M3p4jlvbNke7jmNovj9dUffcFAVHzXT3Wbzk7ULqwvZQL+fWsoEscPQF1VF2
F05LZ+thf0/zI26Ix/QzYWGv7//NL87u0W1OVMW0xFHfVFq/tYwYLqmttZ5SMYhF
E/PCEAdi8FlRArEA6tL0/6RxNdN/lIs36qh4/bso3zKIxqC3LQB0Le6u5OXjJOSJ
sCwv0AbHpTFclH20RyEwBiipT1kuXj73N1jL0jwRhkZMI60ML1v+WkYwBsssZe3w
UQMwmQD7jK9KsW4v0ip9pKVbtZzBtQhRTTlm2QxbsmaHcRqYeUQ2poOEC9Fgywm5
2Ox9Y2IA8uA0MBXDqmIIvFmHIbAzn8KMd5vrFoe0/Yu/lwPRAuoKLz+ojGkwmHzP
wpKjCO92vQyGqHfkLsqoprnb4LoVx2CojSbYvQ30e2oDC2CI5QqfJCDQhUmWTYv6
eOLb0KPbWXaAqiz83AJ5/VDuobXnfHL6NyG5xgl5ee8+4RFLaXn9nxTfHyqCvkEf
PDyjfayvuaKkoh0Pp2brcgWHS4vHr81rI9uNCH3axJaBtD+HsHRd36vkLQmpTUfb
G3PaAxHBJs+U9U81Lxwe
=SzTf
-----END PGP SIGNATURE-----

--=-ZFePMZZXyBKiquGeGYVi--

