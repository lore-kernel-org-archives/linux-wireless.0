Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYBFOKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 09:10:50 -0500
Subject: Re: [PATCH] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <200802051050.22187.bruno@thinktube.com>
References: <20080118125252.6455.41047.stgit@one>
	 <200801251701.59629.bruno@thinktube.com>
	 <43e72e890802021522g5bffe97cg31ba57f6f1f200b9@mail.gmail.com>
	 <200802051050.22187.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CzTjDSZN0IhHzF/XyY5H"
Date: Wed, 06 Feb 2008 11:01:41 +0100
Message-Id: <1202292101.4395.32.camel@johannes.berg> (sfid-20080206_141054_045420_6627165F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CzTjDSZN0IhHzF/XyY5H
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > A solution to this we implemented at Orbit with MadWifi was
> > that instead of generating "random" BSSIDs you'd create one based on
> > the hash of the SSID [1].

> this looks like a good idea to avoid many ibss merge problems, and it cou=
ld be=20
> really useful to have that (maybe as an option?) in mac80211. but unless =
we=20
> have ibss merge functionality you won't be able to join older networks=20
> (higher TSF) which don't use that scheme, so we still need that to be abl=
e to=20
> communicate with other ("standard") drivers.

I think we should simply allow setting the BSSID (SIOCSIWAP maybe?) on
IBSS interfaces and punt this issue to userspace.

johannes

--=-CzTjDSZN0IhHzF/XyY5H
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6mFhKVg1VMiehFYAQLF5hAAxEQEdGBxeKmHcfSDH59nho9K1KKOlXJK
XxlOC33FJYp0EcR17Mq9cuwqrc5fuX0HfwWYoVmLgeA5W2UQfrTQNsWJqKDHpSYF
LijeHJPJhHhi2fALYjfJqpqtT8h7LVvDZZev89eakMu6AOoomQsS0L9TmPXisuGZ
xpZ8CQREPFMg8ClntzU4+Vx/ND316WSo4o3tmSC2YdI0pwDto7iOnTvjMzDxtN+S
GLzPb4Qs6i5L+o6j4qZNKhnVVNydhSRxJXQkRAANSpEkVAZKJa7Bxy+1xrzrGJ/T
x02n0e7MNgsr9cN69XFUGnm/bH36ULSOBFMpgs/8fqb5MDV6N0jhjQlimlXmLlZX
rMtGqe4DcJTOTAT6vzebidNCZ5CAagS9eXvJZlFE0Nmvu17tMQA1WK6BUTssO93a
EmNvL8jCkie91jdr7zDCIHcTUkTB6HwqQSI7wOy3kF/2+rZaBfCVYzGyCcHMnwAQ
NpnlTZaLGdu/7p39ITANtdxVJfkvSXsPlS/J8b1t/WlpjYhoG6pwO5M91yXl6Q45
0bPJyXe6yUCvJTuqYHUP0JvyXsyscrrZ/jDiCb+Jb277aty7XIDjxyBUjP6KjQq+
rXhEZUh8fLZ5eBEerHjBjZoh4U79CQGDJ0FY4GmNcnK6MDPtT13/s7mvq+V7SN2o
p6QGpiCb8tM=
=W4z9
-----END PGP SIGNATURE-----

--=-CzTjDSZN0IhHzF/XyY5H--

