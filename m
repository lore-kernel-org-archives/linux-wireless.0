Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbZLAX73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 18:59:29 -0500
Subject: Re: [PATCH] lib80211: make crypt modules configurable by user
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, daniel.ritz-ml@swissonline.ch
In-Reply-To: <1259711174.13720.17.camel@MacRitz2>
References: <1259711174.13720.17.camel@MacRitz2>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uylhejHlExhqiMNV+O/J"
Date: Wed, 02 Dec 2009 00:59:03 +0100
Message-ID: <1259711943.32171.134.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uylhejHlExhqiMNV+O/J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-12-02 at 00:46 +0100, Daniel Ritz wrote:
> Make the crypt modules configurable by user. Normally drivers select them
> when needed, but out-of-tree drivers can't do that. Having a minimal
> kernel with just the things required won't select any of those modules,
> resulting in the external driver to be close to useless (ie. it can scan
> the networks, but cannot join a single one).

So ... what makes you think anyone cares about out of tree drivers?

=46rom my POV a clear NACK on this, since it makes the kernel
configuration more complex for no useful reason.

johannes

--=-uylhejHlExhqiMNV+O/J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLFa3EAAoJEODzc/N7+Qma+GUQAIMeCxyeuo/HmPLgUrqBXK83
R64td4Ush8S1HsG9RF6Lds5D2C3Dnavkgrk5NJEH2mYHoQbgZzZDFhl1fEEwzTAs
4odda0omGnEJX6g/nvtR6kSbGkmWJMpYlGQCTeCN4WCpwHsf6VGQzBO1I4JIAhnI
v9SS/3Hl9JAw8cMvFIOZ/g0LT1B7VfFNgjG/oysPdtNXCvs1jcZ9odrieuacGbrs
FjZvoy+riFPsMrX53y2/cnDegIZziHJMPE5O+cMFSetrBd5mWHkYjvIWttLVIEI7
LjFSRGxHO8pPBpbdoA0FsSuY3Gnaed6bDFEc5MxQa04UxxdKHmiVwf1BNScc7oqR
wmrFY7XKacObKVuLYXIfestYFGo7SqV7YaQYNG3Rjk5bF/8r8EMEgcbhN5tgqjRr
GZNB/DxJhFMwmfPZWi8Xaf6woTgm7TPjna5I4dS3bHx62HxV3jYjgcYqLU4SkWjD
Jpv5k+IRSg457FU5Vo2xYiFPvTJl+fVZxVHrOqHwuVXB4oEyb1i7CeL3z/A2zN+Y
hNWb32ucl5IC+P68hZYEvnEZ8a6DUwiNew29eDqNdMHatxKduo7iKVMMFl3TqCwo
fanuKNUiy4tNQtbHVtyj48C9ENby2KBQCE9Tng19LqTGulAh8YM2f4Rk8y2bN+Yq
hKEaUAOuCvpIc+Kg2hOY
=Kk7A
-----END PGP SIGNATURE-----

--=-uylhejHlExhqiMNV+O/J--

