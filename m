Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43953 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbXCUOSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 10:18:10 -0400
Subject: Re: question: /sys/class/net/*/wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070321151231.0a912abf@griffin.suse.cz>
References: <1172920691.4966.6.camel@johannes.berg>
	 <1172921257.4966.12.camel@johannes.berg>
	 <1172967669.3402.0.camel@johannes.berg>
	 <20070316150352.5290eea7@griffin.suse.cz>
	 <1174064833.3355.7.camel@johannes.berg>
	 <20070321151231.0a912abf@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sU5f3ebQ0bOVO2TTEQbY"
Date: Wed, 21 Mar 2007 15:16:44 +0100
Message-Id: <1174486604.4230.41.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sU5f3ebQ0bOVO2TTEQbY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-03-21 at 15:12 +0100, Jiri Benc wrote:

> Why it won't work? If you have wext-compat configured, you have the
> 'wireless' directory (and 'ieee80211' as well). If you don't have
> wext-compat, you don't have the 'wireless' directory. But tools which
> depend on wext won't work then anyway, so no difference here.
>=20
> Or am I missing some special cases?

No, that's all ok, but I don't think people (will) realise that wext has
influence into sysfs. Actually, it isn't created by wext-common but
net/core/net-sysfs.c so we'll have to actually make that create all the
stuff with wext-compat too. Which again sucks but may work out
differently after all if James makes wext-compat use wext.

johannes

--=-sU5f3ebQ0bOVO2TTEQbY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGAT5M/ETPhpq3jKURApCrAKCyqtEdsvyVQxiQDTpq1N3FaP8J6wCgnB3y
Pv0CrnHvtU+pMMhtH3Q8wB4=
=egZh
-----END PGP SIGNATURE-----

--=-sU5f3ebQ0bOVO2TTEQbY--

