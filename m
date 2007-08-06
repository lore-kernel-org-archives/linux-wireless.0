Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37119 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184AbXHFKHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 06:07:03 -0400
Subject: Re: further plan wrt. monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200708051129.23301.IvDoorn@gmail.com>
References: <1186178959.13315.30.camel@johannes.berg>
	 <200708041322.14876.IvDoorn@gmail.com>
	 <1ba2fa240708042358x6b206c4bla6f10589fd2cf97f@mail.gmail.com>
	 <200708051129.23301.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/mOiKpmZ9cPQd+AwFgBF"
Date: Mon, 06 Aug 2007 12:09:02 +0200
Message-Id: <1186394942.28655.49.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/mOiKpmZ9cPQd+AwFgBF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-08-05 at 11:29 +0200, Ivo van Doorn wrote:

> those could be send to the mac80211 stack without the DECRYPTED flag set.
> It will be up to mac80211 to take another shot at decrypting, send it fur=
ther upstream as-is
> or just simply drop it.

Come to think of it, that's actually necessary because you may change
keys in hardware but still get packets for the old keys under some
circumstances.

johannes

--=-/mOiKpmZ9cPQd+AwFgBF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGtvM+/ETPhpq3jKURAkFuAJ9wbgdT1aizUfMOdAtvRUOBbISBVQCeM+7c
aOHLyf2peyU5wZUtCICDrbc=
=633f
-----END PGP SIGNATURE-----

--=-/mOiKpmZ9cPQd+AwFgBF--

