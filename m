Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38334 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbXHBNFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 09:05:55 -0400
Subject: Re: [RFC V2] bcm43xx-mac80211: Provide information to allow   transmission rate decreases
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200708021503.53982.mb@bu3sch.de>
References: <46b0f367.p35iGhSXwM+v4QLG%Larry.Finger@lwfinger.net>
	 <200708021337.21285.mb@bu3sch.de> <1186055319.24230.32.camel@johannes.berg>
	 <200708021503.53982.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HR6yUA3iH4nXPj16Y6lh"
Date: Thu, 02 Aug 2007 15:07:14 +0200
Message-Id: <1186060034.24230.48.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HR6yUA3iH4nXPj16Y6lh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 15:03 +0200, Michael Buesch wrote:

> So, what's the point of this "excessive retries" field anyway?
> We already have an "acked" bit. So if it's not set, but we expected an
> ack, what's the point of setting excessive retries in the driver?
> the rc algo sould know _anyway_, as it has the "acked" and the
> "we wanted to have an ack" bits.

No idea. I guess you get to dig through the code and remove it ;)

johannes

--=-HR6yUA3iH4nXPj16Y6lh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsdcC/ETPhpq3jKURAswXAJ90c37BtyLQYspBGdMQGcYg+coe1wCeLR7A
0/ESddzHk60Qv/rkMtq2vHo=
=0aGG
-----END PGP SIGNATURE-----

--=-HR6yUA3iH4nXPj16Y6lh--

