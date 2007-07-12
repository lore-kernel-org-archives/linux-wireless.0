Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762218AbXGMJJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2007 05:09:37 -0400
Subject: Re: [PATCH 2.6] libertas : fix a few wext abuses...
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: jt@hpl.hp.com, linux-wireless@vger.kernel.org
In-Reply-To: <1184210893.18797.16.camel@localhost.localdomain>
References: <20070710213706.GA7929@bougret.hpl.hp.com>
	 <1184188789.28850.4.camel@localhost.localdomain>
	 <20070712004634.GA12148@bougret.hpl.hp.com>
	 <1184210893.18797.16.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FG0x/klzQ1M/KTXhQaLy"
Date: Fri, 13 Jul 2007 00:05:52 +0200
Message-Id: <1184277952.6669.81.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FG0x/klzQ1M/KTXhQaLy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-11 at 23:28 -0400, Dan Williams wrote:

> > 	By the way, from my glancing at the driver, the Libertas
> > driver do select CONFIG_IEEE80211, and then doesn't use it ? It seems
> > to force loading a modules that is not needed.
>=20
> It does for ieee80211_escape_essid, actually.

In fact, just selecting CONFIG_IEEE80211 would force building it, not
actually create a run-time dependency, so the use of
ieee80211_escape_essid is what forces it to load :)

johannes

--=-FG0x/klzQ1M/KTXhQaLy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlqXA/ETPhpq3jKURAnfsAJ9oCWhoZOT0qBX4UQ5blnN54Z+nBwCeN+kp
Z2rkiTbkI650MgTPkLmtRWc=
=llu2
-----END PGP SIGNATURE-----

--=-FG0x/klzQ1M/KTXhQaLy--

