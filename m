Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53961 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945972AbXBPQHz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 11:07:55 -0500
Subject: Re: [PATCH] remove IEEE80211_HW_FRAGLIST flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jkm@devicescape.com>
Cc: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20070216160456.GA6173@instant802.com>
References: <1171569181.5220.60.camel@johannes.berg>
	 <20070216160456.GA6173@instant802.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SH16XWC9vbsSu8gpNWx4"
Date: Fri, 16 Feb 2007 17:07:49 +0100
Message-Id: <1171642069.3575.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SH16XWC9vbsSu8gpNWx4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-16 at 08:04 -0800, Jouni Malinen wrote:

> The reason for this flag was to reduce host CPU load for frame
> aggregation (merging multiple frames (skb's) into one frame. It was used
> to implement one part of Atheros Super A/G enhancements, but I don't see
> those proprietary changes being generic enough to be worth adding into
> net/d80211. However, IEEE 802.11n has similar features that may indeed
> benefit from this flag. As such, I would not remove it.

But we can never submit fragmented SKBs currently anyway, so whenever we
do any 802.11n changes that benefit from it we can add the flag back.

johannes

--=-SH16XWC9vbsSu8gpNWx4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1dbV/ETPhpq3jKURAjMIAKCq2iz3VpzC63l0VstLIsuKcIXVygCbBkyt
2JvMUWAQ854McCXHiG5nL9c=
=QJ1p
-----END PGP SIGNATURE-----

--=-SH16XWC9vbsSu8gpNWx4--

