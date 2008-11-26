Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYKZLUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 06:20:13 -0500
Subject: Re: bss _info_change query
From: Johannes Berg <johannes@sipsolutions.net>
To: Bharat Bhushan <bharat.b.bhushan@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <d9360e520811260112g4710460dj3159e3bfb22c88f4@mail.gmail.com> (sfid-20081126_101227_696611_6F074205)
References: <d9360e520811260112g4710460dj3159e3bfb22c88f4@mail.gmail.com>
	 (sfid-20081126_101227_696611_6F074205)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-p5Jd5lt6wIcNNCbyHTJF"
Date: Wed, 26 Nov 2008 11:02:40 +0100
Message-Id: <1227693760.4613.55.camel@johannes.berg> (sfid-20081126_122019_966892_B44F17FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p5Jd5lt6wIcNNCbyHTJF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-26 at 14:42 +0530, Bharat Bhushan wrote:

>                    I suppose this api will be executed by open source
> mac when it see any change in the bss info, and this might also serve
> as an indication of various events like assoc/disassoc etc. i was just
> walking through the code and found we are intimating assoc info in
> ieee80211_associated but similar call is missing in
> ieee80211_set_disassoc , although we are computing the various values
> changes but there is no function call like
> ieee80211_bss_info_change_notify.
> Please  help  me whether i am missing anything or should we add a call
> to ieee80211_bss_info_change_notify.

Umm, the call is there.

johannes

--=-p5Jd5lt6wIcNNCbyHTJF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJLR68AAoJEKVg1VMiehFYfY8QALAdiESlGSTeap8QtTzB0YKy
ObCyBJmyu4+X3JsOKw3GjkOyZM2faubkpjj8aUvx3YOqbFwvXjiKhAKOPl8qWg+E
O33x5p5pptVwL/yDLdpEL3PbcCMQcIElJJmvuJ1JHfsCSMHrEP5LoES+C8zOvd5w
2NzytbV4XWUeN0abv9mr9mekAZbiQ1sHHXbMxVGeoyGAi3lz7HEqn+LMnW9ZkgM2
WHJRyWpVjayrDoso8ev6B3m3W75FYbaA4Sl0422Z6c85+gh4fL3mU94CG+S/mUJ/
+7As4rgmv4NTdfk5CwJpWFeI4O8pVmPvlq4h2GRYWqgzWFDZoM/bNzRtTtZzqY7l
FDL9/qWd9xYzZSKTx00kVOALwnuzTK1GHOIf70VIBf8uDcmIfjrt+WWO6UjvlFUW
elbrjsfLONGWErjQN6KneR5alNNs8NaGpEFPAXbpFHWpdTCLIOfLuOlpNx0qsgpR
Alos3z1J/YFH5dXGB0k5fmyhaNYLVlBLIclAMHESaqEJ01rRnBRx6u2jRK3kROzk
96R41HTkS4Gvy/I+tXjMzIe1smIO2LDwAhxc270X/R6W9px56yxJA8hWzGxRZVZH
KdhOOBADV1l40r3iEtZ6RHBc1WyZZrv1wiVK0qqQWSdBkosZ8Xdxhj0hw4JzmT0g
AGvC/WeXDFm3FKluvF9S
=uZYM
-----END PGP SIGNATURE-----

--=-p5Jd5lt6wIcNNCbyHTJF--

