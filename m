Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965245AbXBTIZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Feb 2007 03:25:25 -0500
Subject: Re: Kernel bug in bcm43xx-d80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Alex Davis <alex14641@yahoo.com>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
In-Reply-To: <20070219225446.bgyosgww88c8wk80@webmail.spamcop.net>
References: <178298.69840.qm@web50208.mail.yahoo.com>
	 <20070219225446.bgyosgww88c8wk80@webmail.spamcop.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FPW5/ktnG9lc4bpA/WIG"
Date: Tue, 20 Feb 2007 09:25:16 +0100
Message-Id: <1171959916.15489.78.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FPW5/ktnG9lc4bpA/WIG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-19 at 22:54 -0500, Pavel Roskin wrote:

> Once you have reverted the branch, disable CONFIG_CFG80211 in .config - i=
t's not
> ready yet.  This would fix the iwconfig output.

I don't think that's actually true, the iwconfig output typo bug is
present in that part of the code that is always enabled whether you have
CFG80211 or not. You're just assuming that it would fix it because it
did weeks ago ;)

johannes

--=-FPW5/ktnG9lc4bpA/WIG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF2rBr/ETPhpq3jKURAkTlAKC6/lxBUPSwB8Cme2CI/+NWq5w7FQCeNO8N
rYYXoJF6TyHENFZB2MgUZH8=
=a+JN
-----END PGP SIGNATURE-----

--=-FPW5/ktnG9lc4bpA/WIG--

