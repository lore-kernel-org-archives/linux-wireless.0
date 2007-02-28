Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35947 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbXB1IxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 03:53:05 -0500
Subject: Re: Patch to allow specification of interface name prefix
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Larry Finger <larry.finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Alex Davis <alex14641@yahoo.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070228012500.GB4072@tuxdriver.com>
References: <510326.55988.qm@web50211.mail.yahoo.com>
	 <20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net>
	 <45E112F7.9090908@lwfinger.net> <20070226150241.1b5b63b2@freekitty>
	 <20070227111644.784600be@logostar.upir.cz>
	 <43e72e890702271055sc1525ecy54870626125a7fae@mail.gmail.com>
	 <20070228012500.GB4072@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-a3jGN1gim9TgsbmbLFha"
Date: Wed, 28 Feb 2007 09:51:46 +0100
Message-Id: <1172652706.3681.21.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-a3jGN1gim9TgsbmbLFha
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-27 at 20:25 -0500, John W. Linville wrote:
> What about monitor mode?
>=20
> Doesn't airo use "wifiX" for its monitor interfaces?  For monitor
> interfaces, should we adopt that convention as well?

We don't need a convention for monitor mode. Either the user sets an
existing interface to monitor mode (we don't touch the name) or the user
creates a new monitor interface (they get to choose the name up front)

johannes

--=-a3jGN1gim9TgsbmbLFha
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5UKi/ETPhpq3jKURAmiuAKCLdQVZQ6ypCFGgJUYLoA2QYCJGgQCfUz60
j/CXZno/jqCOxwnSpDMdmqo=
=viGY
-----END PGP SIGNATURE-----

--=-a3jGN1gim9TgsbmbLFha--

