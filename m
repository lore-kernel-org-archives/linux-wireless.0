Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbYAXOpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 09:45:45 -0500
Subject: Re: [PATCH] b43: Fix MAC control and microcode init
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <200801222023.35131.mb@bu3sch.de> (sfid-20080122_192602_244741_E21941C1)
References: <200801222023.35131.mb@bu3sch.de>
	 (sfid-20080122_192602_244741_E21941C1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-d+lLzmfDKTMDuDjRWaig"
Date: Thu, 24 Jan 2008 10:13:01 +0100
Message-Id: <1201165981.3454.49.camel@johannes.berg> (sfid-20080124_144831_286456_2F9F0BF5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-d+lLzmfDKTMDuDjRWaig
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This also adds a longer delay for waiting for the microcode
> to initialize itself. It seems that the current timeout is sufficient
> on all available devices, but there's no real reason why we shouldn't
> wait for up to one second. Slow embedded devices might exist.

Your decision, but I very much doubt you can make the MAC any slower
than on the old devices, in fact, on new chips it runs considerably
faster I think.

johannes

--=-d+lLzmfDKTMDuDjRWaig
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5hWnKVg1VMiehFYAQKBahAAh/S10iuKae/F7Gk2ey90BaEnbgO8oGdx
BTSbwmEYkhn6pMmeWAsbgxkAB5X8v2PnRMkmD/ii731UK625aewhh3ITL5kJxYb3
PQjQYxiira9nTdRiH4xGfbFd/K/fBv7vEVEYjlIzcu+pdKe2Cz/8nz7+savoXfOr
A2Lh8GA759liFRdnZ2RmagKe++U31cJGMG/gVcaTcWWIBjYu+SpTmnYnslTpH+NB
/Xeelrgqg9b1dIuXky6RCLi5H9hC8AAadrbPlqZAT81bX8agxDoXfcp8j5TBqzbh
3knSyyb0FnDU3r0mUgZk/+up1MiyYySwQP6S+MTwYhTtXBrZ6kJxQR7+YYm5huHQ
Y3nPQd8zTFe/WwM2diNsf9DydcMjDdo+/PT7JsZkJ07HSS1kAkd8/0UYU3hTU/eU
VYnsvLYWn8qOwjMcWX0bQ5Qn+rcjrdYFbF6jETPuql8Otepzl0GCBweANmQVbqe0
iVo11c+VCFm+pBmrhotFS4v6uwh2wf61kr77IGnuhYRvI7T/XL1j4AKY/IUsoqcu
LqM7hujhygidEvGLADAgSg75SSnR0Sh8g7ce+JUg2gQu3KzhIlU0vUulk7mAj0Qx
l2EKZvKoeT51x/gXkDvPuZwKA56dsR8grvDMCrDQ0/XV0VnNcoJy/mjFhRcyhji+
fA8Ujpb+6K0=
=EhkU
-----END PGP SIGNATURE-----

--=-d+lLzmfDKTMDuDjRWaig--

