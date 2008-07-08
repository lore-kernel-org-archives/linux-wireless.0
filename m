Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbYGHTQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 15:16:54 -0400
Subject: Re: Linux capable PDA with WLAN NIC that supports access point
	mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: pommnitz@yahoo.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <899764.45398.qm@web51401.mail.re2.yahoo.com> (sfid-20080708_205902_248573_ACA5C480)
References: <899764.45398.qm@web51401.mail.re2.yahoo.com>
	 (sfid-20080708_205902_248573_ACA5C480)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ECahphH/vvjiusutxHB9"
Date: Tue, 08 Jul 2008 21:16:10 +0200
Message-Id: <1215544570.3670.7.camel@johannes.berg> (sfid-20080708_211657_711357_E5A7503F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ECahphH/vvjiusutxHB9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I know that mac80211 is not there yet, but on the other hand
> OpenWRT seems to run on a lot of hardware with very different NICs. How
> does OpenWRT implement the AP functionality?=20

Either with hostapd or the broadcom proprietary driver.

> I'm considering a PCCard based NIC with something like the old Compaq iPA=
Q
> PC Card Expansion Pack. In this case an Atheros card with Madwifi might
> work. Does this work? Is there a NIC (Broadcom maybe) that is better
> suited?
>=20
> Is there a CompactFlash based WLAN NIC with an AP capable Linux driver?

There's a Broadcom CF card. I have one, but it's not DMA capable in
Linux because of the PCMCIA subsystem (IIRC).

If you're willing to invest some work, it should be possible to get the
the N810 working with mac80211/p54spi but it's not there yet and I don't
have time to work on it.

johannes

--=-ECahphH/vvjiusutxHB9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIc7z2AAoJEKVg1VMiehFY1WYP/1yX8Re7Z/mHtEl9pi7xEccY
4M4FEjEHYisRbt1BQ4g9+qHTWIIlPN4duXrGji8xUIxcZEmOydLeYY6CWZ+JJhR9
R0UHDqXAqgpl22XR829xlfXavQ+5SoWzqEgeRDNGlmzOeFEx7rfqMRZs5o6Smw+W
tojy2CSyCVNAAs5VwcB9ilFDPtUDIbEYatFC7rOME2ZmNQx3PCPT9tLU4SRjXwcm
T9B9BnEdmPN7P172sHGIu2FwN0EcX11+1g4NCT457uc5LYPSgMiJo4rA+RcXDbvO
9ahlVEah6bIF35xicTf5hkf6fK/4LIdysayGs+UMUA2nCrdO/zqw1lC699Je5mzH
X3ulQuLmTgjyOH79p/l4uY4trA/p3F3hckEas+Rr/TDR9JWlfFzX4D3B+rOckLDI
XV3DcE9y0oNsAvAd5pmLL+OxOqSecxnzemFSi1vjgmgX2BvbBlsCltl280ME7Fqq
5JBFkpAt1sCJa4WLiV994tmChGnA/XTRCtkzQnJNfAdr9Y1HPie3gH6cXqFLGan3
IBF6zY04ZNIX6lOcS4B04lmKCHZlbhLCJAa41brxrB8HjI+7bukzzJtiIZhKhh5h
go7av/hVpPPaM82Tq1NiyUiGZhr9zUY42lxf+7GEh74DwvF0OCcx0FGvI/FHpeb4
z+K6bsO5n0iMLIgx5kKf
=dI0I
-----END PGP SIGNATURE-----

--=-ECahphH/vvjiusutxHB9--

