Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbXHPOrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 10:47:35 -0400
Subject: Re: mac80211 AP mode powersaving problems?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <87643f4kkh.fsf@nokia.com>
References: <1186990509.27916.38.camel@johannes.berg>
	 <87lkccf30m.fsf@tikku.osso.net> <1187270479.5141.44.camel@johannes.berg>
	 <87643f4kkh.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pDa8SA+GCR9O12yo0g9I"
Date: Thu, 16 Aug 2007 16:42:24 +0200
Message-Id: <1187275344.23489.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pDa8SA+GCR9O12yo0g9I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-16 at 17:31 +0300, Kalle Valo wrote:

> Are there any tricks or should this be enough with b43:
>=20
> iwconfig wlan0 mode master channel 2 essid mac80211
> ip link set wlan0 up

Umm, of course not. You need hostapd.

joahnnes

--=-pDa8SA+GCR9O12yo0g9I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxGJP/ETPhpq3jKURAt3GAJ99Csf2Sd+NUybv1YeP6eDtniYjogCfZGyd
StHCI3Ax5ckDK5ELO0jCejs=
=rXX8
-----END PGP SIGNATURE-----

--=-pDa8SA+GCR9O12yo0g9I--

