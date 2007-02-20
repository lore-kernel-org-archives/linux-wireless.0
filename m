Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43609 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965604AbXBTAI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 19:08:56 -0500
Subject: Re: Kernel bug in bcm43xx-d80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Davis <alex14641@yahoo.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <508755.46267.qm@web50206.mail.yahoo.com>
References: <508755.46267.qm@web50206.mail.yahoo.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iFkOL9y/C7PG2Gj3866F"
Date: Tue, 20 Feb 2007 01:08:44 +0100
Message-Id: <1171930124.15489.68.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iFkOL9y/C7PG2Gj3866F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-19 at 15:48 -0800, Alex Davis wrote:
> --- Pavel Roskin <proski@gnu.org> wrote:
>=20
> > On Mon, 2007-02-19 at 13:48 -0800, Alex Davis wrote:
> > > I go the following Oops with the latest wireless-dev git when startin=
g wpa_supplicant:
> >=20
> > Wireless topics moved from this list to linux-wireless@vger.kernel.org.
> > Broadcom drivers are discussed in bcm43xx-dev@lists.berlios.de.
> > wireless-dev is horribly broken, and the fixes haven't been merged yet.
> >=20
> > The current Broadcom driver can be loaded from
> > http://bu3sch.de/git/wireless-dev.git (please load it on top of
> > wireless-dev.git to save bandwidth)

> What command do I use to load Mike's tree on top of wireless-dev?

actually, get Jiri's
(http://www.kernel.org/git/linux/kernel/git/jbenc/dscape.git), he's just
committed the fixes.

To merge it in, just git-pull it (and see the docs)

johannes

--=-iFkOL9y/C7PG2Gj3866F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF2jwM/ETPhpq3jKURAjHbAJ0TUYDYZP82rcyc569ecdLcNpNUqgCfbPgh
13SzJDHWvarNYhY+VBhei2s=
=QKlU
-----END PGP SIGNATURE-----

--=-iFkOL9y/C7PG2Gj3866F--

