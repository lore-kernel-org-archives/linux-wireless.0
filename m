Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53816 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbXHRI4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 04:56:04 -0400
Subject: Re: [PATCH 1/2] mac80211:  Remove ieee80211_privacy_mismatch
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Volker Braun <vbraun@physics.upenn.edu>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070818034146.GC1415@jm.kir.nu>
References: <1187406018.30247.17.camel@thinkpad>
	 <20070818034146.GC1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RDzJqD6hWuJ9xKHQRHGT"
Date: Sat, 18 Aug 2007 10:56:05 +0200
Message-Id: <1187427365.6090.26.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RDzJqD6hWuJ9xKHQRHGT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 20:41 -0700, Jouni Malinen wrote:

> I don't know what has happened here, but ieee80211_privacy_mismatch()
> and being able to disable/enable mixed-cell operations was here for
> purpose (to prevent associating with APs that have mismatching
> configuration by default, but allowing this to be enabled if the target
> network is known to use some of the virtual AP designs that would
> otherwise cause problems).

Actually, that does work, but in the case Volker has apparently
wpa_supplicant fails to set the authentication method to 802.1X via
wireless extensions and thus he fails to be able to associate to the
network. For WPA, it correctly sets it so you can associate without
having keys.

johannes

--=-RDzJqD6hWuJ9xKHQRHGT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxrQl/ETPhpq3jKURAi2FAJ92IjFTHpYWG57IucKuSPln4tuHiwCcDKqL
iw1kKSCRMq1+OiM3ddN+Rv0=
=b+2y
-----END PGP SIGNATURE-----

--=-RDzJqD6hWuJ9xKHQRHGT--

