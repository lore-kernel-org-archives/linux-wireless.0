Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970895AbXHMJAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 05:00:53 -0400
Subject: Re: [PATCH] hostapd: use eapol frames from ethernet device
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1ba2fa240708120358rb22a2f9me1a1020e669406e7@mail.gmail.com>
References: <1186789737.4862.3.camel@johannes.berg>
	 <1186790012.4862.8.camel@johannes.berg>
	 <1ba2fa240708120358rb22a2f9me1a1020e669406e7@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-scPyTgxMKlaOLl5JhCTb"
Date: Mon, 13 Aug 2007 10:51:44 +0200
Message-Id: <1186995104.27916.56.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-scPyTgxMKlaOLl5JhCTb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-08-12 at 13:58 +0300, Tomas Winkler wrote:

> Isn't the removal of management interface a bit premature?  I didn't
> see any proposal how to move management packets to the application
> level?  If not I would prefer eapol packets be treated on management
> path. No data should be received on data interface till security
> negotiation is done.

Have you read the patch or are you just ranting? I'm guessing the
latter? The patch didn't remove the management interface at all.

Besides, what point is there in not allowing EAPOL packets through? They
are fundamentally data packets so they belong onto the AP mode ethernet
framed device, and they won't be interpreted by any other application.
You'll have to come up with better reasons than "I prefer" blabla.

johannes

--=-scPyTgxMKlaOLl5JhCTb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwBug/ETPhpq3jKURAkRQAJ9jAaDN/n52olGYqS9hFtA7AkZW6ACdGei9
rNNjmOicrCAgGCSx/oKIQ7M=
=mUcf
-----END PGP SIGNATURE-----

--=-scPyTgxMKlaOLl5JhCTb--

