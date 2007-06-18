Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761178AbXFRLBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2007 07:01:11 -0400
Subject: Re: phy mode, channel -> freq mapping (was RE: more nl80211/iw  tool code comments)
From: Johannes Berg <johannes@sipsolutions.net>
To: Sandesh Goel <sgoel@marvell.com>
Cc: David Lamparter <lists@diac24.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <285925A4DF50FC408669C6302216838D024899@sc-exch02.marvell.com>
References: <1181759017.29767.117.camel@johannes.berg>
	 <20070614142925.GA24414@charon.n2.diac24.net>
	 <285925A4DF50FC408669C6302216838D024899@sc-exch02.marvell.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-suyVcwxpAF0yBhc3gS+q"
Date: Mon, 18 Jun 2007 13:01:48 +0200
Message-Id: <1182164508.5924.19.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-suyVcwxpAF0yBhc3gS+q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> I think it is cleaner to define a parameter called BAND which can take
> values 2.4 GHz, 5 GHz and so on. Then, the combination of BAND and
> CHANNEL will uniquely define the operating frequency.

<phymode stuff snipped>

> I wasn't sure if this has already been thought about. I look forward to
> being educated if I am missing something.

Good point. I hadn't really considered this but a/g or n cards really
make it necessary to distinguish here, and regulatory stuff would also
benefit from defining it that way.

johannes

--=-suyVcwxpAF0yBhc3gS+q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGdmYc/ETPhpq3jKURAtP6AJ0Ukww/MuLxHSVc4PoEA5Hmu5ggDgCePa47
6FvY6onVgXAMIOHfEpx+xQA=
=ZQ+5
-----END PGP SIGNATURE-----

--=-suyVcwxpAF0yBhc3gS+q--

