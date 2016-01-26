Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:63001 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932681AbcAZIwd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 03:52:33 -0500
From: Marc Dietrich <marvin24@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thierry Reding <thierry.reding@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	Alexandre Courbot <gnurou@gmail.com>,
	Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCHv2 3/4] ARM: tegra: use build-in device propertieswithrfkill_gpio
Date: Tue, 26 Jan 2016 09:52:08 +0100
Message-ID: <7911934.5tJp6vWQjI@fb07-iapwap2> (sfid-20160126_095257_016713_EDC3F5D4)
In-Reply-To: <1453798016.2759.5.camel@sipsolutions.net>
References: <1453712629-143317-1-git-send-email-heikki.krogerus@linux.intel.com> <1626364.s6q6eBGYVQ@ax5200p> <1453798016.2759.5.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1679971.baOqhhWpfy"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1679971.baOqhhWpfy
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

Am Dienstag, 26. Januar 2016, 09:46:56 CET schrieb Johannes Berg:
> On Mon, 2016-01-25 at 21:59 +0100, Marc Dietrich wrote:
> > 
> >
> > seems to work fine. I wish we could instantiate this from device-tree
> > so we can finially get rid of this file.
> 
> That'd be nice - anyone want to propose rfkill DT bindings? :)

There have been at least 5 attempts to do this in the past - all fail. You've 
been warned :-)

Marc


--nextPart1679971.baOqhhWpfy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJWpzO4AAoJEKyeR39HFBtoXMUH/2IE8u7/Fj5UBqUr0fi+qyFV
6UxTjBv90FooFukmOpmJuU3yKeGO5TFfK+W5uZ80GtO7lySjw28Ugw8i+t03uCBi
Vu6Lgh1oRBWghiucwKvFVlmyz1ZqonIZ53swQ3fAk1INX2qtcTyKVQigJy/3yEFR
mFBcpS6q4I8QnUe1sZseB9JUPD/Fu7E3H6xOXQyDVwXy9VwhWRyc7huAoZIvlkHH
b14fXokls7fsKIJa6FFFZPEtRvyBpbki1xcoxMq1NJYFWep1hq50yj+9BNrBAkPv
5PUGxaBm6rRv0epgc4pFt+P/fJikTCcATcOnp+iQBRgMozXn4J39qwJ6F9k/HP4=
=I/ky
-----END PGP SIGNATURE-----

--nextPart1679971.baOqhhWpfy--

