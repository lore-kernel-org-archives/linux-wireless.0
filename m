Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46408 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbYFSMYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 08:24:05 -0400
Subject: Re: Broken fragmentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240806190457w20dfe2d5pf06829b26d2722a3@mail.gmail.com> (sfid-20080619_135746_464579_6D5A208F)
References: <1ba2fa240806190220l18fe5dcdsf44fe81412a5f35d@mail.gmail.com>
	 <1213869365.1312.48.camel@johannes.berg>
	 <1ba2fa240806190446n4d931e6ara4db156900e59e0d@mail.gmail.com>
	 <1ba2fa240806190457w20dfe2d5pf06829b26d2722a3@mail.gmail.com>
	 (sfid-20080619_135746_464579_6D5A208F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v+5ayl8eGHo45H6yUw+/"
Date: Thu, 19 Jun 2008 14:23:27 +0200
Message-Id: <1213878207.8967.6.camel@johannes.berg> (sfid-20080619_142410_842546_D3B208CA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-v+5ayl8eGHo45H6yUw+/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Now it crashes in the driver...maybe the txinfo to cb changes. Looking =
into it.
> > Tomas
> Looks like this is the second part keyconf is null

Part? You mean fragment? What encryption algorithm? I've quickly looked
and all of them seem to do the control.hw_key assignment in their
respective _skb handler so it should be done for all fragments.

johannes

--=-v+5ayl8eGHo45H6yUw+/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWk+8AAoJEKVg1VMiehFYkHAP/2B0xyGKBEnWLIBc5cvkC6w2
NCEki/Sk53ttroFlSr7GwIdV/XCnNiFXwmV1FWgu37at9eSesE8Y5UGagPHZB2WY
2Y8yvwU8DzQaiqqtCAPNBJXhRAOS70nzBQpyGeU97VFz1Rqj24rxXo7EqqwbiHXr
VW6pHwFt59ZPutN+IVykraDWXVr6RnJt7PdFhUhJjwHabZwyjk2ZlaBZPKVGeFrQ
MS7QwYpTYgFAexpX3hka4gvgVoG4vWlfi/86SaqlsL6xXsLhPKsray/MrpjTudck
YUF+z5vtoVQV6kBdclEREjc1vREti6vOc2TFygaNWWZwc4AmROcLl+DrC2ZDCrKg
W9zzeEE8zU9RSltdTEFAyApdCotNo9zW5X6l9EIhVGViRo5XRXeh5RlsgdLLuKwV
9ybbep/oQ77bcLGq8BtRU5nZ/DWlLoasgVq63Na+L+pLWwW9Be/15fJwdKUHqEDw
4PaQzhghOslV4We7hpIMbFJqeTPfl9zDe227urKpUpfpMxMRE05Q4heBbZsJj8Zu
durVecUy+xVC4zGDmlR9GW6MAnFmxGAuaxHjF1T10HXcP2Egyn01F2QeMMn1ZL4q
t42UEA7mGKmSCnKDIz4cQl5CddWdUzFGTA4/YOQa1aGdyCmWkUNqUV4/gDm76tmU
zotTwP0r5jIBg8jRvSe1
=P9dS
-----END PGP SIGNATURE-----

--=-v+5ayl8eGHo45H6yUw+/--

