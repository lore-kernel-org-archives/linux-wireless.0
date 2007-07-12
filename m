Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49262 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437AbXGMJGc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2007 05:06:32 -0400
Subject: Re: Setting channel when interface is down inconsistency
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1184188695.28850.2.camel@localhost.localdomain>
References: <9e4733910707090759v5cd20f2en1f6c4e6fc6279b3f@mail.gmail.com>
	 <1184005862.5671.2.camel@xo-13-A4-25.localdomain>
	 <1184107850.3738.20.camel@johannes.berg>
	 <1184188695.28850.2.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MqZJ2+0KPlu5tSq+oQrn"
Date: Thu, 12 Jul 2007 22:31:46 +0200
Message-Id: <1184272306.6669.44.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MqZJ2+0KPlu5tSq+oQrn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-11 at 17:18 -0400, Dan Williams wrote:

> But, of course, we need to make sure that we are consistent and that if
> we really don't allow configuration when the device is down, that all
> drivers return error when they are down.

If we want to go the way of not allowing configuration when the device
is down we can easily check and return an error in cfg80211; if we do
want to allow configuration when it is down we have to make sure all
drivers support that.

johannes

--=-MqZJ2+0KPlu5tSq+oQrn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlo+x/ETPhpq3jKURAko5AJ93zveY7WQX8mqS81Hz5+5RoZpbDQCbBA3J
29Ss/5x8qstOreC+aE6YY3o=
=pcw0
-----END PGP SIGNATURE-----

--=-MqZJ2+0KPlu5tSq+oQrn--

