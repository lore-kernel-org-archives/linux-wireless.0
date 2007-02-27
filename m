Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39387 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030589AbXB0Kjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 05:39:31 -0500
Subject: Re: [PATCH] wireless: rename d80211 -> mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070227112808.2fc32c6a@logostar.upir.cz>
References: <20070227032756.GA6569@tuxdriver.com>
	 <20070227112808.2fc32c6a@logostar.upir.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bLx/aMRsdcGDgHzF8v1z"
Date: Tue, 27 Feb 2007 11:39:06 +0100
Message-Id: <1172572747.3870.234.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bLx/aMRsdcGDgHzF8v1z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-27 at 11:28 +0100, Jiri Benc wrote:

> When we are at it, I think the module name should be 'mac80211.ko' and no=
t
> '80211.ko'. This means renaming of mac80211.c (I suggest mac80211_proto.c=
 or
> mac80211_main.c). Does it sounds reasonable? Should I make a patch?

This has bothered me for long. Can't we just call it main.c? I mean,
it's in mac80211/main.c so there's no chance of confusion... What's the
point in having mac80211/mac80211_something.c?

johannes

--=-bLx/aMRsdcGDgHzF8v1z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5ApK/ETPhpq3jKURAqVLAKCyBOeWs55yE92JHRF5X1Bbm87dXgCggcCf
RlzFHlgJKCT0tL6UHspXsbg=
=1A2A
-----END PGP SIGNATURE-----

--=-bLx/aMRsdcGDgHzF8v1z--

