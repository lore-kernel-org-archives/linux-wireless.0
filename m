Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57959 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbXHQLZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 07:25:39 -0400
Subject: Re: [PATCHv3] mac80211: dynamic wep
From: Johannes Berg <johannes@sipsolutions.net>
To: Volker Braun <volker.braun@physik.hu-berlin.de>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1187308221.23489.91.camel@johannes.berg>
References: <1187151162.3253.18.camel@thinkpad>
	 <1187308221.23489.91.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LLqc74zFDrEH2Zeb+EiK"
Date: Fri, 17 Aug 2007 13:28:27 +0200
Message-Id: <1187350107.23489.167.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LLqc74zFDrEH2Zeb+EiK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 01:50 +0200, Johannes Berg wrote:
> On Wed, 2007-08-15 at 00:12 -0400, Volker Braun wrote:
> > 1) Instead of hacking around ieee80211_privacy_mismatch, remove it
> > completely. It serves no useful purpose.
>=20
> The purpose seems to be to avoid associating to BSSes that have privacy
> enabled when we don't have any keys nor a tool told us that it's ok.
> This again raises the question of why wpa_supplicant doesn't set the
> IW_AUTH_KEY_MGMT_802_1X flag that should get you around the mismatch
> check.

In any case, I don't mind removing it, but if you do it please also
remove the stuff related to it from ioctl.c and the key_mgmt variable.

johannes

--=-LLqc74zFDrEH2Zeb+EiK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxYZb/ETPhpq3jKURArvyAJ9+hSs0a2p1eZBQLeopUJS3klFIMQCfQmyD
3BBgQpuF7NXHLk0nQGlYTQk=
=L+/P
-----END PGP SIGNATURE-----

--=-LLqc74zFDrEH2Zeb+EiK--

