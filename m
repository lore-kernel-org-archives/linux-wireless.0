Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbXHTLX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 07:23:58 -0400
Subject: Re: [RFC] mac80211: fix software decryption with b43legacy
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46C752FE.4030706@lwfinger.net>
References: <1187346385.23489.157.camel@johannes.berg>
	 <46C5CC0D.2040609@lwfinger.net> <1187384230.6090.7.camel@johannes.berg>
	 <46C612E8.4020604@lwfinger.net> <1187387215.6090.13.camel@johannes.berg>
	 <46C64777.1000602@lwfinger.net> <1187453173.6090.33.camel@johannes.berg>
	 <46C752FE.4030706@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-shbv1PTr9nicvw2NlHVc"
Date: Mon, 20 Aug 2007 13:20:48 +0200
Message-Id: <1187608848.6090.84.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-shbv1PTr9nicvw2NlHVc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-08-18 at 15:13 -0500, Larry Finger wrote:

> eth1: No ProbeResp from current AP 00:1a:70:46:ba:b1 - assume out of rang=
e

odd.

> I don't know why this happened. I didn't move away from the AP, or do any=
thing that should have=20
> caused loss of a probe response; however, immediately after that, I got t=
his GPF:

I'll look into it, thanks.

johannes

--=-shbv1PTr9nicvw2NlHVc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyXkQ/ETPhpq3jKURAp1QAKC7kmhYDRsqzTiX6A42pPwCS9l6wwCfXu3U
UC5mECYgunQyNtzMsQr4dtU=
=DRxE
-----END PGP SIGNATURE-----

--=-shbv1PTr9nicvw2NlHVc--

