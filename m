Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbXH1IrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 04:47:20 -0400
Subject: Re: mac80211 AP mode powersaving problems?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <871wdphsus.fsf@nokia.com>
References: <1186990509.27916.38.camel@johannes.berg>
	 <87lkccf30m.fsf@tikku.osso.net> <1187270479.5141.44.camel@johannes.berg>
	 <87643f4kkh.fsf@nokia.com> <1187275344.23489.6.camel@johannes.berg>
	 <871wdphsus.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mSO3Z48VvBezWBh+yw6m"
Date: Tue, 28 Aug 2007 10:48:31 +0200
Message-Id: <1188290911.7837.65.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mSO3Z48VvBezWBh+yw6m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-27 at 18:58 +0300, Kalle Valo wrote:

> Heh, I guess I have used madwifi too much :)=20

Heh, yeah, the BSD folks insist of putting all that functionality into
the kernel because for some reason they believe it'll magically make it
more stable (they told me that, minus the "magically")

In any case, I'm fairly sure the TIM is just wrong, if you have a third
device you could try capturing the beacons and check that the TIM is
never updated.

johannes

--=-mSO3Z48VvBezWBh+yw6m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0+Ff/ETPhpq3jKURAhxFAKCLEBIk2VTcCKsdLkox/UQhu9hZ2wCgp+t7
u693f3vrIILH4UixlMTQzko=
=K4Zx
-----END PGP SIGNATURE-----

--=-mSO3Z48VvBezWBh+yw6m--

