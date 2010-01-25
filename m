Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab0AYPyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 10:54:38 -0500
Subject: Re: [PATCH] mac80211: fix sw crypto
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Jochen Friedrich <jochen@scram.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1264432868.6336.3.camel@maxim-laptop>
References: <1264415776.23766.34.camel@johannes.local>
	 <1264432868.6336.3.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZwEGD2Mm/+UH+uelqcqs"
Date: Mon, 25 Jan 2010 16:54:32 +0100
Message-ID: <1264434872.23766.42.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZwEGD2Mm/+UH+uelqcqs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-01-25 at 17:21 +0200, Maxim Levitsky wrote:

> > Obviously, that broke software crypto. Maxim
> > said so specifically, and Jochen probably uses
> > some cipher that iwl3945 doesn't support in
> > hardware, which might also explain that Maxim
> > reports that even hw crypto is broken.
> This patch works for me. Thanks.

Thanks for testing.

> What chipers does iwl3945 support?
> I use CCMP, and I also know that software encryption is used by default.

I don't know off-hand, but I'm pretty sure it doesn't do TKIP, or at
least the driver doesn't.

johannes

--=-ZwEGD2Mm/+UH+uelqcqs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLXb60AAoJEODzc/N7+QmacRkP/3LvG+NK5s45wTfXv8GruSv/
B7CgLZzpwdwLL+LnrABoUEoDuvJe0j0ht7lhYwo9uc1H4a+8tH6MOJByhNaXqI7G
8eQy/57L09OgbPpm2WMmpDjYQm0cos073YtiJbj9g1A4PelW5aNX9DEzwxX1BQoC
MKIcn/p3g+RRWRSGlFOpK8lYXsn7olkakj/ukcTkqFq4DYq7ilBhFIwp2dv9TdWz
BCTZ5GzZ2bksMpqxIeIyi3kR9kY5KMCIxGlhLx9D3oUqNIcn3RuiJS/XSpoP3NVY
Sarmoo9DmVUgwX0vgKOm7kbxkzUo0ifkta1U5pOir1/xgGQBL2IQwQ50Lws05Rkn
F/Z5a6/BJQUaKgKnVSxnJK6GDmCfTXYUdrytjrTkjD1Iwh81np4wuygSEV2ejrB6
HodWGWg8J3s5nk2whTcMVLzMupe8N0H1VmYTxfi/oWTxDREwTLElHka81DDptGAq
QF66++UXAeLnncJNPOGn4lIXqVY2BTL0Mp06AIAbFTSZQjdbgJ6PCFNbA8ElV/HQ
sffK1omw/MgT7rf9JxuLwQzTSYNawfdR+22Biu19dOONhv3IX0eLTOcuru1OHbny
BOk/N0lf3OyFSPxme2BmK+7rsRgyW4OpZTtNguVN/5kVikjJByMRfKT8ustFnjEn
ZbAVeoWyRgRy2xNx3h6E
=5Ivm
-----END PGP SIGNATURE-----

--=-ZwEGD2Mm/+UH+uelqcqs--

