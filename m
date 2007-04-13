Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbXDMPQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2007 11:16:11 -0400
Subject: Re: [PATCH] bcm43xx-mac80211: Fix machine checks on PPC with rev   1 PHYs
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Bcm43xx-dev@lists.berlios.de
In-Reply-To: <461F9C58.6050106@lwfinger.net>
References: <461d0815.ip3FDr8RDQXyCT4U%Larry.Finger@lwfinger.net>
	 <20070413113638.10db9767@localhost>  <461F9C58.6050106@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sfGeU8T6PvRdYz2ma0VA"
Date: Fri, 13 Apr 2007 17:17:46 +0200
Message-Id: <1176477466.7052.114.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sfGeU8T6PvRdYz2ma0VA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-13 at 10:06 -0500, Larry Finger wrote:

> I look forward to your rewrite of the setup and init routines. Perhaps th=
ey will even let my 4311=20
> work with mac80211, but I will be very surprised if the PPC machine check=
 problem goes away.

With phy rev =3D=3D 1, the gmode bit is assumed unset when initialising a G
PHY. Maybe that is the crucial difference. David will send me some
backtraces of this problem, once he does I'll look at it again.

johannes

--=-sfGeU8T6PvRdYz2ma0VA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGH58a/ETPhpq3jKURAk9fAKCi5+Xj0OKyXgcJxYgW7Kxtz5WQOwCfX5D7
dbkH+WkgtA8BMQHznFcasmk=
=CEd9
-----END PGP SIGNATURE-----

--=-sfGeU8T6PvRdYz2ma0VA--

