Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbYBYTXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:23:37 -0500
Subject: Re: mac80211: Roaming issues.
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <005101c877e0$2ded1170$0b3ca8c0@gotws1589> (sfid-20080225_185644_237646_16C3B889)
References: <005101c877e0$2ded1170$0b3ca8c0@gotws1589>
	 (sfid-20080225_185644_237646_16C3B889)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-85WucjhYoWmq2FWcl64Q"
Date: Mon, 25 Feb 2008 20:23:29 +0100
Message-Id: <1203967409.13162.134.camel@johannes.berg> (sfid-20080225_192340_680478_F71C0C45)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-85WucjhYoWmq2FWcl64Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> Parallel with that I have been testing the roaming performance in differe=
nt
> environments/sites.
> I have discovered a number of improvement to the mac80211 driver that wil=
l
> significantly speed up the roaming function.=20

Nit: mac80211 isn't a driver, it's the generic stack that is
used/cooperates with many drivers for many different types of hardware.

> The actual roaming is of course
> controlled form the wpa_supplicant,=20

That's actually true only if you use wpa_supplicant which with open
networks you're not forced to.

> but with my patches, the
> mac80211/wpa_supplicant will cooperate much smother and faster.

Sounds good.

> My question are:
> - Is this the place to discuss the mac80211 driver ?

Yes.

> - How is 'responsible' for the mac80211 driver ?

I pretty much am, but also see the MAINTAINERS file (still lists Michael
Wu and Jiri Benc who both don't do anything any more). Please copy me on
all patches, but of course send them to the list.

johannes

--=-85WucjhYoWmq2FWcl64Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8MVsKVg1VMiehFYAQIhMQ/+I74G5g9KEfp88NeLdAcYNs8wVj48pHKf
GBPAMZ9dHjGYS50BDg4svHhnSrfDocamMEmv7J2BmJuLzQIUOToYLGLuAYJxcgrS
AjQpbGJ924RUjqPDoFYfuG7MPyv1Bqcb6Zats5hQhQKboLRpoVWb6O20wiakasHB
K5NW9eLJPaBUzsfIk7YYoQOGIEqf4uA82hp6X7+LjuJ+AmQMX7Th9+ZqJ37pJvSt
NLxbSHXbqN/80lAUtsJBJ2rjozjqgIx+nrPSr8LXEM1vB5bIIkyhyeZnOawiWH3U
gpfvhYOF3PtiJNEiwAR45+w1mzZ4NzE9Q5IJC4LEybMw4cdS7QYI31fhnoOAvVuh
BdzM0BPz/u1RyyjL8ie8WHDGWHnWgmXrx0LblGfddFnuH+4+Nm6E2fFQaICKIE8V
hsb9FIabHKsg2UOzBA6nEBKdSpUpsNXG9H8Ga3kDvMiW0fFAoKkGXi3ibZhdmyKs
hOqGWkNDxZEO31+iCfduHP6EFkbhuV6WMd0D7bp59gS0yEpKqQ5Bfr7KUPfQ+0Og
bzSxsTBWU0I1ibRXF/XC39SBgSZPTpl4U9EG21Wg1ip2xu388ak30gtdwD+Q81+Y
a3R99VHEtVIS9/2rol5Cc+/3aB6EOF1sAZgD9YLuvygPp3lkf4mRVtjvEL502Jai
AruL1zfttEA=
=wIux
-----END PGP SIGNATURE-----

--=-85WucjhYoWmq2FWcl64Q--

