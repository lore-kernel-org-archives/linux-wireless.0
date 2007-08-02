Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41595 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbXHBLQz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 07:16:55 -0400
Subject: Re: [RFC V2] bcm43xx-mac80211: Provide information to allow   transmission rate decreases
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
In-Reply-To: <200708021311.25033.mb@bu3sch.de>
References: <46b0f367.p35iGhSXwM+v4QLG%Larry.Finger@lwfinger.net>
	 <200708020014.15072.mb@bu3sch.de> <1186045787.24230.7.camel@johannes.berg>
	 <200708021311.25033.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9SqYD8cJm0Pt5TNRlFpQ"
Date: Thu, 02 Aug 2007 13:18:17 +0200
Message-Id: <1186053497.24230.27.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9SqYD8cJm0Pt5TNRlFpQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 13:11 +0200, Michael Buesch wrote:

> We don't get a "I failed to transmit this" bit from the firmware,

Well, if you expect the frame to be acked then you do get a bit 'this
frame was ever acked'

> so we must work around this my comparing the retries count to
> the maximum possible retry count.
> Of course, that's not an ideal solution. Especially because I think
> When it succeed on the exact last retry, we take it as failure.
> Though, that's very unlikely it fails 7 times give or take and then
> suddenly succeeds.

johannes

--=-9SqYD8cJm0Pt5TNRlFpQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsb15/ETPhpq3jKURAkRGAJ9hTym62sXGv+LD5NGrY7fk5PryXQCfaf9K
c8wijKz3vzvfXlG27voE7xA=
=SSNH
-----END PGP SIGNATURE-----

--=-9SqYD8cJm0Pt5TNRlFpQ--

