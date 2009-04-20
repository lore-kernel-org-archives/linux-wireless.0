Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbZDTRUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 13:20:45 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1240247636.5260.11.camel@localhost.localdomain>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fq5+f876HNZSoe73mcH1"
Date: Mon, 20 Apr 2009 19:20:08 +0200
Message-Id: <1240248008.4632.10.camel@johannes.local> (sfid-20090420_192051_228357_F67A1E7D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fq5+f876HNZSoe73mcH1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Marcel,

> Trying to authenticate with 00:1f:3f:19:d8:b7 (SSID=3D'Holtmann' freq=3D2=
462 MHz)
> Trying to associate with 00:1f:3f:19:d8:b7 (SSID=3D'Holtmann' freq=3D2462=
 MHz)
> Associated with 00:1f:3f:19:d8:b7
> WPA: Key negotiation completed with 00:1f:3f:19:d8:b7 [PTK=3DCCMP GTK=3DC=
CMP]
> CTRL-EVENT-CONNECTED - Connection to 00:1f:3f:19:d8:b7 completed (auth) [=
id=3D0 id_str=3D]

> Associated with 00:1f:3f:19:d8:b7
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys

> Associated with 00:1f:3f:19:d8:b7
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys

> Associated with 00:1f:3f:19:d8:b7
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys

> Associated with 00:1f:3f:19:d8:b7
> WPA: 4-Way Handshake failed - pre-shared key may be incorrect

> Associated with 00:1f:3f:19:d8:b7
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys

> As you see it keeps scanning, authenticating, associating and then it
> never completes.

> And this is the debug output from the kernel side (latest
> wireless-testing with all debug options enabled):

> wlan0: associated

> wlan0: beacon loss from AP 00:1f:3f:19:d8:b7 - sending probe request
> wlan0: beacon loss from AP 00:1f:3f:19:d8:b7 - sending probe request
> wlan0: no probe response from AP 00:1f:3f:19:d8:b7 - disassociating
> phy0: Removed STA 00:1f:3f:19:d8:b7
> phy0: Destroyed STA 00:1f:3f:19:d8:b7
> wlan0: authenticate with AP 00:1f:3f:19:d8:b7
> wlan0: authenticated
> wlan0: associate with AP 00:1f:3f:19:d8:b7
> wlan0: associate with AP 00:1f:3f:19:d8:b7
> wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=3D0x431 status=3D0 ai=
d=3D2)
> wlan0: associated
> phy0: Allocated STA 00:1f:3f:19:d8:b7
> phy0: Inserted STA 00:1f:3f:19:d8:b7

So far so good

> wlan0: deauthenticated (Reason: 2)

This is confusing. And it keeps happening:

> wlan0: associated

> wlan0: deauthenticated (Reason: 2)

> wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=3D0x431 status=3D0 ai=
d=3D2)
> wlan0: associated

> wlan0: deauthenticated (Reason: 2)

> wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=3D0x431 status=3D0 ai=
d=3D2)
> wlan0: associated

> wlan0: deauthenticated (Reason: 2)

> Do you need anything else? I have really no idea what happens here and I
> like to get it fixed.

Can you do the kernel log with timing please? It seems strange to get
"previous authentication is no longer valid" from the AP as a reason
code while associated.

johannes

--=-fq5+f876HNZSoe73mcH1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7K7FAAoJEKVg1VMiehFY3WsQAMZ/WWGdjg0OHzsRqGuB5Ays
8kjb2ylAtA6dFHfLhKFQXXJ9s3aJCIqO3f62E4i16vm+bpjyAreAdzLRM99zW4Cz
1l0i0Hg5fkf8s1vFIdXQWh6KqLm5P8LF8T28HONVElLh8vka/kUZquWerlxY29LN
g2QAguxtuDA410ZtFY+0U3ha/teG+2JZzCoWIzVANMyBPBZrFN5BL+cnJ018i+Qa
efuWnWnYwt/bVs87FjNa6jdV/P0NmG3FXv25mZnbeCBAhzwdqsKXT89THfQfQAdQ
+XO6RPvK6eq89W+UNvQ/Q5mmNO7d5itQSAQ9QNuLHgtFOhoiTJ6btMHri9M9ROgM
dPZBk55XgwQKwYWxmAqrx92Eknh57abm/6fnCw38BnSw+PkVuG/XeSR7jqmUCsqt
QZwQ82lSnTG5XHz0Jxk31zu557NSh10AKXfJhGtbZvgpJb3opNv/cshLGf9jeBaq
sOxoQMeS/eaOzNErkh9ZfOSZ9J0L7WFkfKMDt1kVyPkaeC66L2uIBLzt9Uda4Tcv
hFVDx0N8OIiLRNutZlrNtqVwtnGOF08jcJaR6IPGAXu/q5Dz1DgkAnek8sUf29tP
ONiB5X0zxl1Ym/CHVGFnjYhRwT27M4ZN1XemKsc7TAjEaFncBRxM5aqYUDro2g7f
/KqOJyKbrs/WqlgC3s+l
=d/gN
-----END PGP SIGNATURE-----

--=-fq5+f876HNZSoe73mcH1--

