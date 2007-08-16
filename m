Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131AbXHPNSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 09:18:35 -0400
Subject: Re: mac80211 AP mode powersaving problems?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <87lkccf30m.fsf@tikku.osso.net>
References: <1186990509.27916.38.camel@johannes.berg>
	 <87lkccf30m.fsf@tikku.osso.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tzQS6kVLceNH8J9SB6m2"
Date: Thu, 16 Aug 2007 15:21:19 +0200
Message-Id: <1187270479.5141.44.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tzQS6kVLceNH8J9SB6m2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-16 at 08:43 +0300, Kalle Valo wrote:

> One thing which came to my mind is that when Nokia 770 is in PSM it
> uses PS-Poll to fetch the frames from AP.

Yeah, I noticed.

>  Few devices do that, so I
> wonder if mac80211 supports that properly?

It should, as far as I can tell, but I haven't been able to quite
pinpoint it yet. I'll need to get a third device fully monitoring.

johannes

--=-tzQS6kVLceNH8J9SB6m2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxE9P/ETPhpq3jKURAg8mAKCDijeMRiEgRgfxmDYJ6GKzY+iIkQCgnUWB
pdPJiv+Gnbd+yud942CQT5U=
=PQVV
-----END PGP SIGNATURE-----

--=-tzQS6kVLceNH8J9SB6m2--

