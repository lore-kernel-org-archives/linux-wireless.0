Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57186 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888AbcAICyE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2016 21:54:04 -0500
Date: Sat, 9 Jan 2016 03:53:57 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Uri Mashiach <uri.mashiach@compulab.co.il>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, bcousson@baylibre.com,
	Igor Grinberg <grinberg@compulab.co.il>,
	Eliad Peller <eliad@wizery.com>, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 1/3] wlcore/wl12xx: spi: add power operation function
Message-ID: <20160109025356.GA3644@earth> (sfid-20160109_035410_855110_62C6C789)
References: <1451482533-8624-1-git-send-email-uri.mashiach@compulab.co.il>
 <1451482533-8624-2-git-send-email-uri.mashiach@compulab.co.il>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
In-Reply-To: <1451482533-8624-2-git-send-email-uri.mashiach@compulab.co.il>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 30, 2015 at 03:35:31PM +0200, Uri Mashiach wrote:
> The power function uses a consumer regulator access to update the WiFi
> enable GPIO value.
>=20
> Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>

[On Nokia N950]
Tested-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWkHZBAAoJENju1/PIO/qaIQQP/i8ZiaJwN33NbHUyK92MOZCD
RPzaAllnH9Z93TVodoiSv/CrereUAAKGXOdT2voV8j+KyguKhnjxoC5gpEiF9mUH
d6bY/mA/wGOn6ucDoxjGL4bh5M6RPozwdvZIkWA4GXrixn0bULdllIEABcqBnect
tPXC/N3CTrNwCKqa+Dj4kPHUa7x0NPWmppOINw3Zh4oISfeqzXvQdbkmKDz2+Wgn
uMOien57bQUSVSy68r4z8oCbXwIuwffgr0EHQsWjmCFsAj1bhkUqwOhz+cWAxXis
Tvzf4O3pBFrPot4LxCO3wxDmRrnEw29Ua6ZnAJtvhRoDPXzIRk1qEqbpB5GgQL2Z
mIo/J2NK8a3tu6guD9JwAJaj9wgB13faid9GvROTJSifpgprLTRDtMlbvRcI7pWd
FE3t4sr17iHyLBQpTbwVBK7P0NYzHy4Zhj2LlliCMoZdqVwyR79rvcuOxAW3s9po
9Fpr+yWsk1y82zrY0+dwtaRxrg03tSs7GdOytbvqiBLnyxB2Oi2P944Pd9Q94mMw
AQrZgXMWwZ+JeII8GLX0iU70y+v9vGUsXVF7BqZo32uIFxEHoINgD/KncMnZ8T31
Q9L8y5cfGUy0pnRFu3D1D38c6UzTnhuwgwn4UBZV1BLh0SXgraUQWpFPDb4xqRSO
Ve1Jg5vNc9Tmt/uqg5GW
=KsZ3
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
