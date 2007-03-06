Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59846 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030503AbXCFNMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2007 08:12:13 -0500
Subject: Re: [FYI] compiling hostapd against latest wireless-dev
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jkm@devicescape.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070305164417.GA10947@devicescape.com>
References: <1173095902.6131.63.camel@johannes.berg>
	 <20070305164417.GA10947@devicescape.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HeQxV0wuVEUYuFeprDNj"
Date: Tue, 06 Mar 2007 14:08:29 +0100
Message-Id: <1173186509.3403.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HeQxV0wuVEUYuFeprDNj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-05 at 08:44 -0800, Jouni Malinen wrote:

> Which version of hostapd did you try to compile here? The current
> development branch does not include net/mac80211.h and the include path
> has also been changed from net/d80211 to net/mac80211 in example
> configuration.

I was a bit in a hurry and just downloaded the latest release. Thanks
for the heads up, I'll give the dev version a try.

johannes

--=-HeQxV0wuVEUYuFeprDNj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF7WfN/ETPhpq3jKURAqSNAKCZgiVUVIfVJr018Ixca1ztx/LNbQCfSmVp
OfHSaeYphR47CyeILsiUP7o=
=5n/z
-----END PGP SIGNATURE-----

--=-HeQxV0wuVEUYuFeprDNj--

