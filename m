Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44925 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZCVKjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 06:39:37 -0400
Subject: Re: [RFC] staging wireless crap: tell people not to work on it
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <87ocvtg83i.fsf@litku.valot.fi> (sfid-20090322_113411_129130_27C4CA24)
References: <1237714803.5100.770.camel@johannes.local>
	 <87ocvtg83i.fsf@litku.valot.fi> (sfid-20090322_113411_129130_27C4CA24)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JaOPlzxVZsggb/G1oZZ5"
Date: Sun, 22 Mar 2009 11:39:33 +0100
Message-Id: <1237718373.19647.0.camel@johannes.local> (sfid-20090322_113945_535092_AC43C72C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JaOPlzxVZsggb/G1oZZ5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-22 at 12:33 +0200, Kalle Valo wrote:

> > --- wireless-testing.orig/drivers/staging/at76_usb/TODO	2009-03-22 10:3=
1:37.000000000 +0100
> > +++ wireless-testing/drivers/staging/at76_usb/TODO	2009-03-22 10:31:37.=
000000000 +0100
> > @@ -1,2 +1,2 @@
> > -rewrite the driver to use the proper in-kernel wireless stack
> > -instead of using its own.
> > +Work on at76c50x-usb instead, possibly using
> > +this driver as a reference.
>=20
> I already sent a similar patch to Greg:
>=20
> http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-sta=
ging/staging-at76_usb-mention-mac80211-port-in-todo-file.patch
>=20
> But there's no mention of at76c50x-usb. I'll send an updated version
> to him.

Ok, I'll drop that bit.

> (I hope this mail manages to go to the linux-wireless list. All my
> emails from yesterday got lost for some strange reason.)

It did! :)

johannes

--=-JaOPlzxVZsggb/G1oZZ5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxhViAAoJEKVg1VMiehFYZIAP/219B4iRzMCQ0Rjj8vf86Kwh
ui522ROpjGQ3vXFq7LMq98MnXYyEn60PkOAOIyDEtiETgWUuhUqYAR6eJTZMIPA6
xFNrbFIP1v5M5TFjaV7NYC6e7nxGoGFW/ziZryt+pEajdj7KTrA6yFYsbmzZkI2l
WqSDKK/x5dAgC0qrnvHGI1GtcKnKeauNWRo2dh/vf4fCfuCcxbG4ItucrAy1Hjv2
btCJFLWl5aEc/ZzGgHgieK2zwLnI+MlmnGLzr3JbohriNkH/h+jXYgRslRgjRoLl
RRh8FDHvglxUrcwoGfBsJ8m5q9jW2o5gtd75K++c0tLOCS7Je+FIxdHes0oMrd8/
39wpVbDPoMxJDbSkv02ge5w36w039IDHQKodHwR4endkveCX+GVpsx/rD1RotwG9
PyngJDMb/h2suZlriDzqca7sk3MVZ9R4OZ9Bi/aLqSbhjNnKLkrHyrxTCRg10LtS
cI92au/gA5xFSsNqQ1y/RMQ9bmwsEIVff2w2CNN0MTugrtb69HNFFR/sggZMBSr+
P9UjJRNni0yUDgGmECtEaUg9rN7kX44HwzCxuyfyYkLMXfCWjMvaT8hFwKyRGhdV
HD0C3ZD1akb4LqOcSDamsbDVq+vVyDQg078fMfcPglaNu6oZXDzQ9Pl6raKEVn6R
uy/yoson7ypCncOyYv0v
=hWew
-----END PGP SIGNATURE-----

--=-JaOPlzxVZsggb/G1oZZ5--

