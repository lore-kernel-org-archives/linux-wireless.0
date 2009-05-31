Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbZEaJ6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 05:58:15 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: alan-jenkins@tuffmail.co.uk
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pldhEIeBLu0nhMMb7Ws2"
Date: Sun, 31 May 2009 11:58:07 +0200
Message-Id: <1243763887.19302.29.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pldhEIeBLu0nhMMb7Ws2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-05-31 at 10:13 +0100, Alan Jenkins wrote:

> If I read correctly, userspace can write to the global states, but
> can't read them?  I think it's awkward to implement rfkill-input in
> userspace without being able to read the global states.  The daemon
> would have to save the states in a file, in case it is restarted.

You have a point there, but I'm not sure it even cares? When restarted
it will probably want to impose its current policy anyway? It would be
easy to add that we send the global default value for newly added ones
too but I'm not sure it's necessary -- Marcel?

johannes

--=-pldhEIeBLu0nhMMb7Ws2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKIlSsAAoJEODzc/N7+QmaED4QAKd9bWnRCwBMiwCl/WK+eldH
Gd/Bhm+KrBjxyIm4eIyt/SUz0T+TVMftbLnXBMtlZJt5J+n6hFeVV+V7KybAXY5Z
15qlCWgV/uFbuUJ/jiEyo5Jom1vryv2KnfUGIH29+O/qyh5VBCsTw4c7iijgPil7
c1eBYCPf/mgD1dkjwoo0hQxVs0vRxXu8xgvK8PLaU0ARe2z1+AfPQmxP89Ec1YPw
psPYIhLZo9Rd/2co1D8l1J7RaI26tWdQO5HcHUhFOdnuhLutzzoLPuIgk+6ZoZXv
ipd3aeDwcyDDMuQ38FND1v0l7R4VXbvF6b5Q82vRWcpp57n4L+uE80bSio99Wy0N
UfpgAN9I5S7CdhAqGZkBK4sKOU7pguSDe9pBeGX+R9v2s/mNZF9RISOGoT5A5m78
dfPkc56wO8UV8nUifMuzxvbkgXOnGEw59pa7AkKOCJQbfFvQM+rjDGiuO4odCiZt
qJj0d86eObX1qLGLQpGHLKb96rHigI0VvgWv/lyzsL1rrigO4JEWeaXw/591vzHx
/z2IPtF0xEOz8N/Cqs1vPIgsGLNTVp9Mv2OxL6nimfb0q3GnVueRbMjcUIrEuV/i
tsp+KA/vL097PeRaQHjwnbOgTbpoOwb8m0aVTdTJGi/DFKYZEs3lvKNfjEpIOIqF
6tFn7/uXSJAT2aPM7+r6
=mrvZ
-----END PGP SIGNATURE-----

--=-pldhEIeBLu0nhMMb7Ws2--

