Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbXHUKJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 06:09:20 -0400
Subject: Re: [RFC] mac80211: fix software decryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Michael Buesch <mb@bu3sch.de>,
	Michael Wu <flamingice@sourmilk.net>,
	Jiri Benc <jbenc@suse.cz>,
	Volker Braun <volker.braun@physik.hu-berlin.de>
In-Reply-To: <46CA7127.1070904@lwfinger.net>
References: <1187346385.23489.157.camel@johannes.berg>
	 <46CA7127.1070904@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MDK8ZBiIZ9EsvEXCTNE0"
Date: Tue, 21 Aug 2007 12:06:42 +0200
Message-Id: <1187690802.4288.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MDK8ZBiIZ9EsvEXCTNE0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-20 at 23:59 -0500, Larry Finger wrote:

> Using the large patch you sent me plus the one that fixed the crash due t=
o usage after freeing, I=20
> can now connect using both WPA and WEP. My settings for the hw->flags is
>=20
>         hw->flags =3D IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
>                      IEEE80211_HW_DEVICE_HIDES_WEP | IEEE80211_HW_WEP_INC=
LUDE_IV;

Neither of those actually matter for b43legacy, but that's ok.

> With WPA, I no longer get those messages;

Great :)

>  however, I get a lot of those "No ProbeResp" messages with=20
> a subsequent reassociation rather often as shown in my log fragment
> below:

That's a bit strange. I don't see right now how my patches could be
causing it but I'll look into it.

johannes

--=-MDK8ZBiIZ9EsvEXCTNE0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyrky/ETPhpq3jKURAvWsAKCeQ8yApKTu/frz1c4eEQufMUyI0ACfU0TZ
wQardM/FY9JY8X5ngBAi+Tg=
=IYQy
-----END PGP SIGNATURE-----

--=-MDK8ZBiIZ9EsvEXCTNE0--

