Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39372 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbYI1RVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 13:21:19 -0400
Subject: Re: [PATCH 1/1] mac80211: send action frame when toggling SM PS
	mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240809280939x31829a25wa46948d1f351c7a0@mail.gmail.com> (sfid-20080928_183956_003883_65BD06B4)
References: <1222618493-19019-1-git-send-email-tomas.winkler@intel.com>
	 <1222618769.7064.0.camel@johannes.berg>
	 <1ba2fa240809280924n1505e049w7800e3ef28449e8e@mail.gmail.com>
	 <1222619168.7064.3.camel@johannes.berg>
	 <1ba2fa240809280939x31829a25wa46948d1f351c7a0@mail.gmail.com>
	 (sfid-20080928_183956_003883_65BD06B4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GgtHvPzukPTM3z1VTgoA"
Date: Sun, 28 Sep 2008 19:21:14 +0200
Message-Id: <1222622474.7064.6.camel@johannes.berg> (sfid-20080928_192122_717136_8323C58E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GgtHvPzukPTM3z1VTgoA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-28 at 19:39 +0300, Tomas Winkler wrote:

> Second example, only low level driver is running calibrations and
> knows if it has all rx chains available. The possibility is
> that not all platforms connect all antennas or physical environment
> between AP and STA cause some of the antennas not affective
> we may propagate rx chain status to mac80211 but if this is not
> opening too much guts. Sometimes it's just hard to keep a clean cut.

That's what I wasn't really aware of. Generally I'd advocate giving
mac80211 lower-level details though and let it figure out the rest, that
makes it easier for the driver save copy/pasting code.

> I have two more patches for these to example of course...
>=20
> >I don't actually know what that is anyway though, hence the question.
>=20
> Actually this is one of more understandable part of the spec.

TBH, I've never actually tried to read it, I pick something once a while
but haven't ever really tried to get a complete overview.

>  We
> > keep adding API in mac80211 and nobody really knows when to call it.
> > Maybe you should (maybe team up with Atheros for it) write a "HT
> > hardware with mac80211" chapter in the documentation?
>=20
> Yes we should.

:)

johannes

--=-GgtHvPzukPTM3z1VTgoA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI370EAAoJEKVg1VMiehFYRhAQAJkwbn8wTeXcqLocR1fB9WHm
qofMnMwN9+Wpaz9PmqLRxan6eE9tznUGC2O2iAMv0eRNxBMoQR7G1dXnZ5JU5HDq
DymAuaVUwm+/u+aN819qULU/xhMtAhrgjrYxo8LBnPdSUtl6Te4VU668SQn9p6lN
FNvnYPPgFtl3K+aFNG9QLVGNKSy1mSbdMAr8M/wEYAOfibDY6tAfBu9zJjvRN+2a
KwkHHDGsaWdooYPud5XYtdXVcOFkb2EN9Jy8YDh8IcVsanS8AU3aNoEbzQ0cYN07
WYYK9+v/0gB7MZKmS566xMgKpLhmmGlOpn4dt+LnIzqb8mkrY+GsUT/XnVI5IY1w
AaWDCbKT0iH8e5uGlm57TrkV5nSY4Eszxue1xhl5VWlkOqnTx7ZJkv84bYoIB+Oz
x0CIvNxdZhgGVa9D2JSQvFxNAB6drmnOzIETX9rpqKRIL/FJbcjZd1M6pD/11GKF
qOV2DY7Fm7Qq1gNq7Ss2uy3VXp3Jpsv/fuD58pUAUR6lCJkIXIDE6C2CRClmAZLl
fl1R3ahtbTzwQMCKt0cC6YDZmOUI/qG2rZgIX8svxzebEhvCxEBf31ovwUlwe6Cb
ZrzZ8OTcbKzO0X6ZkZ/q9BEsuL9v4q6mnT36flPGWjFOnd3xXgyiU+qzuwWWPhaW
aGri+CxZfsOJ/H5FGW1T
=59sL
-----END PGP SIGNATURE-----

--=-GgtHvPzukPTM3z1VTgoA--

