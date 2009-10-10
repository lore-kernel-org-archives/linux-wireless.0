Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45154 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbZJJSks (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2009 14:40:48 -0400
Subject: Re: BUG?  I can reproduce "Association request to the driver
 failed" at will
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com
In-Reply-To: <200909211309.40476.hs4233@mail.mn-solutions.de>
References: <200909211309.40476.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-h7gug7T6b4eXVh3jvSEd"
Date: Sat, 10 Oct 2009 20:39:58 +0200
Message-Id: <1255199998.4095.41.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-h7gug7T6b4eXVh3jvSEd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry to warm this up ...

> 1253527140.795498: State: COMPLETED -> AUTHENTICATING
> 1253527140.795515: EAPOL: External notification - EAP success=3D0
> 1253527140.795530: EAPOL: External notification - EAP fail=3D0
> 1253527140.795542: EAPOL: External notification - portControl=3DAuto
> 1253527140.795559: nl80211: Authenticate (ifindex=3D34)
> 1253527140.795572:   * bssid=3D00:13:19:80:da:30
> 1253527140.795587:   * freq=3D2412
> 1253527140.795598:   * SSID - hexdump_ascii(len=3D5):
>      4d 4e 57 50 41                                    MNWPA
> 1253527140.795630:   * IEs - hexdump(len=3D0): [NULL]
> 1253527140.795643:   * Auth Type 0
> 1253527140.795683: nl80211: Authentication request send successfully
> 1253527140.795707: RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][R=
UNNING][LOWER_UP])
> 1253527140.795725: RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
> 1253527140.953161: nl80211: Event message available
> 1253527140.953200: nl80211: MLME event 37
> 1253527140.953216: SME: Authentication response: peer=3D00:13:19:80:da:30=
 auth_type=3D0 status_code=3D0
> 1253527140.953243: Trying to associate with 00:13:19:80:da:30 (SSID=3D'MN=
WPA' freq=3D2412 MHz)
> 1253527140.953257: State: AUTHENTICATING -> ASSOCIATING
> 1253527140.953270: wpa_driver_nl80211_set_operstate: operstate 1->0 (DORM=
ANT)
> 1253527140.953284: nl80211: Operstate: linkmode=3D-1, operstate=3D5
> 1253527140.953901: nl80211: Associate (ifindex=3D34)
> 1253527140.953919:   * bssid=3D00:13:19:80:da:30
> 1253527140.953934:   * freq=3D2412
> 1253527140.953945:   * SSID - hexdump_ascii(len=3D5):
>      4d 4e 57 50 41                                    MNWPA
> 1253527140.953977:   * IEs - hexdump(len=3D24): dd 16 00 50 f2 01 01 00 0=
0 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
> 1253527140.954064: nl80211: MLME command failed: ret=3D-114 (Operation al=
ready in progress)
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^^^^^^^
> 1253527140.954086: Association request to the driver failed
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 1253527140.954113: RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][L=
OWER_UP])
> 1253527140.954131: RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
>=20
>=20
> The "Association request to the driver failed" will
> be shown even without "-d". Also note that the association
> seems to actually work, e.g. I can ping throught the
> connection.

Could this be related to the problem Maxim has been seeing? I'm not sure
how else this could happen since you seem to auth but then assoc doesn't
work, but I can't see how that could possibly happen.

johannes

--=-h7gug7T6b4eXVh3jvSEd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK0NT7AAoJEODzc/N7+Qma+6UP/2otK6Zlja3eDPTvQjg3RPFW
vIy+SADz8Kbj6a/Vy0+tqqJ4c+PGF+z8RxJcM0keF2Tu86iLCVLIDf+teBQBbz01
y3s+bbSUKo7llRbOgNXuVGtdtTOzSNE1oFxAV4aNyKLZmJljne3LQS5MOclHhcmU
tKx2oKpa9lFkMfUlzhTWerGV7+eSp0T3ldURb5LGlQ+SrNwvLxqSq49349jGVyQe
7l9n/mfF9ZAiEMc4dG+MUyYbXaF5KW8N5MR5z/31b/ggXto0TOOu0SA8hzcECvHk
LqiRXwtnoP0XALT2OD/wx03t9MRgTpCQqHi4wPjPCjv6EfHVX7Dwnp9jNtPlk0wu
pnfcGfPdv+/1rO0seJol69C0Qq517OmjWKeuInLjVrZYx9tNQnF2q4Gi7hNiouET
IHN8PsIXHVJ342AHHBKldlvA/mulRkSzlivFyto4p2Pop0eGWjZ2C7Qij7S+5qu9
6cUAPH3yS26vtjdU/zuenwgAKqnuhefuz5ZnJ/gUerHju/wl43uZHuNyjh3rJjVv
yA1spbImcRFKv/kytN36gmP9YRHX4r3030UYXrRoB/A+Me8rDdarYBpw3J4HC3t4
+JzO9sW8Zb5OdVlbwa8+UJwGCtXI3pj+X53g1ag5qWVEt7hLYZeq2B2jhZbHl9ed
T975DpDjIYvhzmP/jczz
=FN1h
-----END PGP SIGNATURE-----

--=-h7gug7T6b4eXVh3jvSEd--

