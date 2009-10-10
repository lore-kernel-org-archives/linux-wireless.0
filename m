Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934617AbZJJSlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2009 14:41:11 -0400
Subject: Re: BUG?  I can reproduce "Association request to the driver
 failed" at will
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com
In-Reply-To: <200909211309.40476.hs4233@mail.mn-solutions.de>
References: <200909211309.40476.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-C6Ko+frAg9bkBRBAn+Ia"
Date: Sat, 10 Oct 2009 20:40:05 +0200
Message-Id: <1255200005.4095.42.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C6Ko+frAg9bkBRBAn+Ia
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

--=-C6Ko+frAg9bkBRBAn+Ia
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK0NT/AAoJEODzc/N7+QmaNiQQAMD1a0mspVKaVC07y0BlYhPb
bsJGUIj7sKRLYOIQSGmuaHqG2Cv5stRAlHG/3wEJXmK3Ja9Xs7YKlLpx6ioL495E
8zFUwmJvAwHEtpNpH2ten/ot0WqVUTy8qrhwLsbipu4D7CY66PZfIrO+UatoeDu2
9wtz4yehyktqFzBWmvMRqR3TFMh7HY5owdslDrkVtF9ApZJ+FCg/RGndNoivR4PS
c8B1HA8NknmTGRGEbo+F8Y56Dz4OrH4hjaXQ1F46dq3AKmEDmSei9lUeCkd3AECW
XLJZgl8q4FIbgfTskTueCGuxh6yTcpAZXqvObh+OyGwDXmURc4ByQJnM4VsDyExR
Q9e8QvkD9XFz89a3xQqNhLZfCXYPdrB/x9N/1dewjtogShfzO7u/HBXoXrVoHVpc
ixcnGfPWMer7LXXkpBdvGNxJHyth0q7dHpmz6omkHzhN/z68PmMLKiDMW/yOU6YL
UHyNF0abC7bh68CzPe+7/lnDInhAcAHIwjxaqdF/f/L2tfdYcQwCKtb31WIUIZql
3ZRJIiTxxK3jLnXlzm2IPJ+NO3VslPNEK1FN6n+a7uhKdMmrvLrXd9OvquGarSva
J+bd02OIkerpaMUaA4TyZsBLKRtxlb0MRnSAzo5IPmUnhQS6HIa45Yr/SoCo5meM
S5voYRZr54PzvcKDOMax
=a2Cs
-----END PGP SIGNATURE-----

--=-C6Ko+frAg9bkBRBAn+Ia--

