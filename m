Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZAFSit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 13:38:49 -0500
Subject: Re: [PATCH] Fixed BSSID step 1: Disallow to set multicast BSSID
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090106183543.241290@gmx.net> (sfid-20090106_193614_541329_7F48D123)
References: <20090106014135.302730@gmx.net>
	 (sfid-20090106_024205_979845_6893AA18) <1231247805.3503.13.camel@johannes>
	 <20090106183543.241290@gmx.net> (sfid-20090106_193614_541329_7F48D123)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lSYKrBgU011U4wZR5xZd"
Date: Tue, 06 Jan 2009 19:39:08 +0100
Message-Id: <1231267148.3654.15.camel@johannes> (sfid-20090106_193853_347884_4DDA9399)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lSYKrBgU011U4wZR5xZd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-06 at 19:35 +0100, Alina Friedrichsen wrote:
> Hello Johannes!
>=20
> > These look ok to me, with proper changelogs. Thanks. You should have
> > made the subjects
> >=20
> > [PATCH 1/5] mac80211: Disallow ...
> >=20
> > etc. and also line-wrapped the changelogs, since these are fed directly
> > into git normally.
>=20
> Okay, but can I do this with the next patches and not repost all this aga=
in?

I'll leave that to John to answer, he gets to do the work if you don't
repost.

> Is there somewhere a git repository, with all the new patches merged?
> So that I have link where other people can download easily the newest
> version and test it, to maybe look for other problem in the ad hoc
> mode, before it is in compat-wireless.

well, wireless-testing, but compat-wireless is updated nightly, iirc.

johannes

--=-lSYKrBgU011U4wZR5xZd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJY6VJAAoJEKVg1VMiehFYOCoP/0Ec1zcMNaVNVgeJw+lve7Hn
+SsLsgssK9OUmT+FQVoH7W5WnNXYMp0TSruGM4T8TBfHJVoqZzUZ+Gd94dWE9EkD
vfxH/GrrHJjCV6GxoJFBMlQXf3J3WAJq2GIvLE7asH+DaCM9VXaTuiXuT4CNM7Sj
ni/96VwqSXUH5yZi/FPWH1+4wW97MO33Wb/UbLf5P3eQ9MlNulOkH5yntUPz46aV
mfbwI9RB+h3X3WOy5ImoZZJ+XCvvkgC7JWGqKWA6MDN+/X0iSRas1X8Exk/hWvID
UfzKf4zhUcwAaG5ooA8cL9SjcO8Oje1SlDVIMhWWgWtbhx1g8QpDMYt3csu5vwYh
5OHcSKQmwf81QyK4xA7TD0cigiPeDe0E53qawWJUbaMcGVnXRGyTE7vtiXsZ+lIB
w5O4b+pzKiodQnLk7WpggVIsy0IPP5WVdv0MFNeRFUUK/QCHoGm0J4emxXHzBxvk
5AarKvc383Xy4ya9dLhHZFkV+2dX/43ZZtFdUQbTFcfTOgLsglt6hbYy9g8vkboS
ytY30lL5V67VPP7xXHF535lLOnYeQvzfFguLhs7xmqnSmLyHaXmVGT8IJvKfdwBl
SeatySGpX/s9FDCtF+lPzBjN5UJGKDz4mZRi/+cnjlljH/txESnj8wF0bQ65yDdD
35HDcGyQY29oW+wv55zY
=aTrd
-----END PGP SIGNATURE-----

--=-lSYKrBgU011U4wZR5xZd--

