Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbYCFSrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 13:47:42 -0500
Subject: Re: [RFC] mac80211: handling Qdisc issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com
In-Reply-To: <200803061927.09891.IvDoorn@gmail.com> (sfid-20080306_182740_080358_8A7D236B)
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
	 <200803061902.33865.IvDoorn@gmail.com>
	 <1204826767.25502.135.camel@johannes.berg>
	 <200803061927.09891.IvDoorn@gmail.com>
	 (sfid-20080306_182740_080358_8A7D236B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GA+meVSy5Ruz0WNzKFRW"
Date: Thu, 06 Mar 2008 19:47:23 +0100
Message-Id: <1204829243.25502.137.camel@johannes.berg> (sfid-20080306_184750_156102_63E0E005)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GA+meVSy5Ruz0WNzKFRW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > You could also just make a patch for exactly this and ask Ron to merge
> > it together with this?
>=20
> Well that patch would then be completely untested (I code, but have hardl=
y time
> to perform the testing myself).

Heh ok.

> I can already say that the patch from Ron will work despite the my
> remark about the different meaning of the qid field.

Oh if my (I'm to blame for the rt2x00 changes, not Ron) changes will not
totally break it that's fine then.

johannes

--=-GA+meVSy5Ruz0WNzKFRW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9A8OqVg1VMiehFYAQIHZw//brDFetxn0zA11xX+ANcl9lWMgQXRm787
vDja9BObkRlUj2QO9XE2udfD9lz+M92pgSmpaZkKGiV7LVKqbZizOoV43TylExcd
e8sTbEzEOy5vGTbbgLxfoxIwup1h+HERaVFDDGGba4AfWHg75au0EGtQkBqaWagy
EPrMGTXQPAT7SFCP9077y2zO1oOOgBtqPQJDeGFOQUtJ5X3gYNRShq185NAbWv+D
sZL9n0sHy81W5dCOTvt/ySc3ts42zhlqv/DrUm8Gyy1xb1dDd7G/aM8McwC0Yos8
I5GKq4SzaW6pCjYAM6vpRGSosrP+dsxj3EndU6Ai3VUopUy8WWeROiSD0QJUZ5p6
Z2HTI7gJ+rhdRnXOs9kwq7ff9OFksRwyyq2tqJr+Uge2nCO7Z6TUaiO7rqMZ07HK
qgddSI0+UcwPDRHXKpcXDW5VJf516kni3R4xm0FIIBiKm+fZjC9cm/UNSjQWJ/f7
9ek9ooE7cVEBmocoXdPnmnRqi2ZmiKRTEpxhut3iQuBSO1kL5z7W0H7uR7mX6pPp
b3w8HdkWbZhuP2/4dfSGnq5Hzlbg1833viZVAC3PFZ9j4I5w/OAjH7jAv0tazY9G
5Nld336p4P2lRFgZ2pIc2jJ6+Etn11z1QzRF+IrLCtYGLMAyXsoS5W/BmitXQ6tw
T+PM1W92234=
=yjqh
-----END PGP SIGNATURE-----

--=-GA+meVSy5Ruz0WNzKFRW--

