Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYKFOvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 09:51:48 -0500
Subject: Re: [PATCH 1/2 2.6.28] iwlwifi : Fix channel scanning/association
	in 5Ghz band
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1ba2fa240811060647x688f1efp1728e5f80dbb6b35@mail.gmail.com> (sfid-20081106_154710_192457_283691F4)
References: <1225912449-26625-1-git-send-email-reinette.chatre@intel.com>
	 <B887D922-0154-4365-A44D-F284A5DF9386@linux.intel.com>
	 <20081106134950.GB14184@tuxdriver.com>
	 <1225982253.3619.233.camel@johannes.berg>
	 <1ba2fa240811060647x688f1efp1728e5f80dbb6b35@mail.gmail.com>
	 (sfid-20081106_154710_192457_283691F4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UPR7o/74eBDQH2i+zoc3"
Date: Thu, 06 Nov 2008 15:51:43 +0100
Message-Id: <1225983103.3619.242.camel@johannes.berg> (sfid-20081106_155153_529126_FCEFC16C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UPR7o/74eBDQH2i+zoc3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-06 at 16:47 +0200, Tomas Winkler wrote:

> The problem with missing A band is that this info was supplied to
> driver too late. after registration otherwise
> the iwlwifi dealt properly with missing band This was change in design
> that wasn't reflected in the driver.
>=20
> This can happen _regardless_ of the setting of old regulatory,
>=20
> With old regulatory the channel was known prior to registration

Ah, you mean the driver wasn't updated (and previously not prepared) to
handle changing regulatory information?

johannes

--=-UPR7o/74eBDQH2i+zoc3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEwR7AAoJEKVg1VMiehFYR+8P/jwnEmFSWkHWPbF+AMoShA9C
9ejfzoQ2oqzZed3qPn+qIwAZy4DYh7bQSnSYn1mq2XOWfO6S/U0U/09omO3A1Z70
9+uY5Yf120wqat75xJ7wX1QAuyjmwnxXqsPL/ZPHioNh2KY8cSYPfLCzniOmcmau
fG90n3zubLKszdd/vx3g+ZSmRpOJIINoUEpJHIUqTR4jt/bPJrLHD0bOXKWcVjl4
b/HyznxujLFMOqkgDODrpBwpI5omy3SWXf6t54qgcFqE8HDtN7jEGphXm3QBhdCn
C1ZhpC/mDtym6JtBUuxYdAgL4fFlTJJpSqVZDy3xV9sZxO4Lswi+bNJ/dHgpFVY1
HzKJOVJkVffoKgyT4dK485QN1qD8dQbFFnLKbrXaFH17BqPLXYYwOe0UU5xQ1Ccw
/LzlINajXBCpAF/CnAjcs7AYVUO678KqBOFCcLty7Noz/rbmGHEysZxfCTXhUS0F
mXjMw0owRDGbqN3bK3fBdo9Zzui0FQTgggFRG5aYZUA6QOb4LHnpwJW1jiPscmgS
7dGSgYjcetRb41NN40hqAh43xE6RefIyimZSZ/URGVYL/5zLVURAb99cdCv6NMir
G5Pf3HzC8FQR5az7dcKOjalhfhB4tNhz6orrWMzaUvZgvhxyzhi0IeomCNht8H0A
6TZzXRDTK0ueINDhVikf
=Mn5C
-----END PGP SIGNATURE-----

--=-UPR7o/74eBDQH2i+zoc3--

