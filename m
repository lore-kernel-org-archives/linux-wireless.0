Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33912 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbXITQjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 12:39:48 -0400
Subject: Re: Please pull 'z1211' branch of wireless-2.6
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net,
	jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, kune@deine-taler.de
In-Reply-To: <46F2A1D4.9030601@lwfinger.net>
References: <20070919181005.GB5483@tuxdriver.com>
	 <46F19DD0.2050605@gentoo.org> <20070920134730.GC6748@tuxdriver.com>
	 <46F28374.9040106@gentoo.org>  <46F2A1D4.9030601@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zSri8TA2AM+FuxHR7iwl"
Date: Thu, 20 Sep 2007 18:40:51 +0200
Message-Id: <1190306451.18521.90.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zSri8TA2AM+FuxHR7iwl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-20 at 11:37 -0500, Larry Finger wrote:

> You're on. BTW, I will let you be the primary tester of "[PATCH] fix soft=
mac lockdep reports" that
> Johannes posted earlier today. I see you were CC'd. I plan on testing it =
with bcm43xx, but I won't
> get to it for a couple of days.

The only thing it can possibly fix is our race against some other
functions that use the global workqueue and lock the RTNL from within
the work function while we have it locked while flushing. Conversely, it
can't really break anything either.

johannes

--=-zSri8TA2AM+FuxHR7iwl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8qKT/ETPhpq3jKURApx9AKC2G9Ce0qqwXOaqtG/b51uxCkIeSACguuQ0
WCYNk9qZ0iTX9FFwwnxs6N0=
=LU49
-----END PGP SIGNATURE-----

--=-zSri8TA2AM+FuxHR7iwl--

