Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbXFNJHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 05:07:43 -0400
Subject: Re: [PATCH Try#12 3/3] mac80211: Monitor mode radiotap-based  packet injection
From: Johannes Berg <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20070613093943.738206787@warmcat.com>
References: <20070613093732.535166329@warmcat.com>
	 <20070613093943.738206787@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S0HV8XuYl7TK4uNFZP+c"
Date: Wed, 13 Jun 2007 20:56:26 +0200
Message-Id: <1181760986.29767.137.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S0HV8XuYl7TK4uNFZP+c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-13 at 10:37 +0100, andy@warmcat.com wrote:

> +	control->flags &=3D ~(IEEE80211_TXCTL_USE_RTS_CTS |
> +			    IEEE80211_TXCTL_USE_CTS_PROTECT);

> +		case IEEE80211_RADIOTAP_FLAGS:

I suppose that IEEE80211_RADIOTAP_TX_FLAGS and
IEEE80211_RADIOTAP_F_TX_CTS and IEEE80211_RADIOTAP_F_TX_RTS could be
supported as well...

Also IEEE80211_RADIOTAP_F_SHORTPRE and IEEE80211_RADIOTAP_F_DATAPAD
(though we never generate frames with that afaik) ought to be
possible...

However: *please don't do it now*. This mail is mainly meant as a note
to myself to do it (unless somebody else wants to do it...), adding it
now would probably open discussion on the patches again and we'll never
finish...

johannes

--=-S0HV8XuYl7TK4uNFZP+c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGcD3a/ETPhpq3jKURAl74AJ4rQlum0Zn5i73tme2mK+En77ADlgCgqzY/
s3zioSJApTj/0KNXjnGs5cQ=
=IsEn
-----END PGP SIGNATURE-----

--=-S0HV8XuYl7TK4uNFZP+c--

