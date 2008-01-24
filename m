Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60801 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYAXO6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 09:58:16 -0500
Subject: Re: [PATCH] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: bruno randolf <bruno@thinktube.com>, mcgrof@gmail.com,
	jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <87ir1ja9om.fsf@nokia.com>
References: <20080118125252.6455.41047.stgit@one>
	 <1201099729.3454.17.camel@johannes.berg>
	 <200801241443.40067.bruno@thinktube.com>  <87ir1ja9om.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lM330XMLkyOrJoUdzFBQ"
Date: Thu, 24 Jan 2008 15:27:56 +0100
Message-Id: <1201184877.3454.86.camel@johannes.berg> (sfid-20080124_145819_553414_85AA846E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lM330XMLkyOrJoUdzFBQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> > Do you care to explain what's so bad about function declarations?
>=20
> I don't know about Johannes, but I just see them as unnecessary
> burden. If I change some parameters in a function, I'll get a compiler
> error and only after that I realise to change the declaration as well.
>=20
> With public (ie. non-static) functions it's a different issue, because
> I know that there's a declaration in the header file. But with static
> functions this is not the case.

Seconded. I also see it as totally unnecessary if you structure the code
properly in the first place.

johannes

--=-lM330XMLkyOrJoUdzFBQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5iga6Vg1VMiehFYAQJJUBAAva9eyUkYGBPVI4XDejgfPzAkQZ1RjsTs
QX1udOiy9dw6lvkC15SofsEM7jkoLfqV4aDzegCXdGpXqFzr1143YwShaoWn84/l
iDhOfjOYZInZwpvX0d80J5jgZsCwq3efy3bSx/yzcrvyvcM608wDwrXQP706oWeJ
hpy5qVII3XsdgXwLJhrqA9U7E7KCOkLn0vj7xFu2mNemlZZlDMRy3FAenrQDpTew
cC0bIMlZ48gXQJfjUBNpczXWe46XenZQzGuuYkjrdl+wgmjNLpSXhKsnWwHHAdhL
BlCR0+nYkHfcxv0Bxphss7x+9ktB7tUfYyXgyQqw7FAHtPU4ulWbLoS7Ap8RnIJP
WPubSaB8OiQ8S1ym4mPBRExGReDU1KQsfAvsIPcXZ0WQKiU92bxQ2F5894lG0Umw
Hg72YZzoPZhtm3cXiiHmSM9DJtUl2ju9jgF6+o39xhKXmPN4iKB41ACz0/j7ecv0
H1MnJF/OE1cRB1i4EyIVu6yH1N0tZpxKXDSjnBobgapPT2k/JISYjQfchPI/0UME
6x4nXmxCcVaU+IRLnKGpp3rqtvxGwJGccFtkv4aVqDAs+1W5G67u6Ep1BmZFkeyx
DFRmwmqL83whP4AdCRy6C6oZtw4S/jo39v3Qx+jQCiDqiuZN4cK8KYSDyxy4RBVn
cgp7B0BN8LQ=
=euFc
-----END PGP SIGNATURE-----

--=-lM330XMLkyOrJoUdzFBQ--

