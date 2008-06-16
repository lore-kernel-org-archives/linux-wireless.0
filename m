Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40224 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbYFPQs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 12:48:26 -0400
Subject: Re: Management frame protection and packet injection from hostapd
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1213634684.3803.43.camel@johannes.berg> (sfid-20080616_184528_507886_E873544D)
References: <20080616143308.GB18479@jm.kir.nu>
	 <1213627991.3803.38.camel@johannes.berg> <20080616153421.GC18479@jm.kir.nu>
	 <1213634684.3803.43.camel@johannes.berg>
	 (sfid-20080616_184528_507886_E873544D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0iOGHwJblGVNagu7eMg9"
Date: Mon, 16 Jun 2008 18:47:48 +0200
Message-Id: <1213634868.3803.45.camel@johannes.berg> (sfid-20080616_184831_554091_586E5A5F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0iOGHwJblGVNagu7eMg9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Yes, that sounds likely since the changes I did for debugfs were very
> > trivial copies from CCMP/data-default-key processing. I'll debug this
> > more and try to figure if there is need to re-order something or make
> > the debugfs entry removal able to handle such a case.
>=20
> Ok. I don't know right now, and it does seem to work correctly here, but
> maybe it doesn't when the application doesn't explicitly remove the key
> or something, I'll take a look.

It's definitely done, from ieee80211_free_keys() calling
ieee80211_debugfs_key_remove_default(), maybe you missed something
there?

johannes

--=-0iOGHwJblGVNagu7eMg9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIVpkwAAoJEKVg1VMiehFY1LQP/Ay4wBMXwBeEfrGznToR23K9
VFqS1UpaHWuxhSWevB92faaVu3qUD6F/cn0qTWhRUiTGIYGA53DeegPOhNxSrf4r
95ncRq9KCZWvTIblvTMrIaVu1vYH503X7fZinsfzA/XX1zr1AMU4UnQq9S+QahRo
CxD3975fW31vRDHG8RuWl8KvmBHyFVDVj+pA/oM1YRAZrrObmRUtJ2qwJhr4RWWf
7vF455060cWCHfD57/s0DYjuUK6ALoMC/0jScPKUUfgTyeIBT85v8e/UiMk+GaEb
u8AKwxQ91sYnQ95pV9hLJ7uiGeEmmeMPssAmA0Dufjra6d8nysbEtjLCtuu0oyEW
eUce1EhGr0abeR9SU5EPIQyk0lS5W2ev9YS/mckt0dobIjrx/t1n4ANF+yx6ec3v
77VfxDwVNiWFrlXSFfs93tJuEsnUkFZmiJ9E3HktKiQ7h2P6erOt6cgx7th/qKgv
tWheJP9D+UFJn9unxmge6Ls2NVkGsaMyaUObftjRnf3qG3k+Stc67ugyp0RAu2Y2
ZlAoAVDm1IXrwtGpbhS4+rTA37RnW6oolHALiU5JiHmYBAn5P9mt2aup8pQXjamj
Trl1dgryExPTVjQt+MnG1PHPjJFYz9xtZ8nX77RF0M19WpHGNpXm/fiyfnW8uK4H
RvLeWNFIS5BrOkWo+yE6
=GVLN
-----END PGP SIGNATURE-----

--=-0iOGHwJblGVNagu7eMg9--

