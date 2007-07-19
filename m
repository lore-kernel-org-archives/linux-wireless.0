Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59724 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbXGSW07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 18:26:59 -0400
Subject: Re: bcm4301: A mac80211 driver using V3 firmware
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070719215801.GB12449@tuxdriver.com>
References: <46963C0F.3080104@lwfinger.net>
	 <20070719215801.GB12449@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AwbQr9n70mnrMO8J1oLM"
Date: Fri, 20 Jul 2007 00:26:34 +0200
Message-Id: <1184883994.17966.14.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AwbQr9n70mnrMO8J1oLM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-19 at 17:58 -0400, John W. Linville wrote:

> Regarding hardware support, I have begun to lean towards having
> the v3 driver continue to support all the hardware it does now.

I agree, until we can sort out the issues with that.

> What exactly do we gain from using the v4 firmware?

We get crypto hardware working, for example, and other things I might
not remember :)

johannes

--=-AwbQr9n70mnrMO8J1oLM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGn+Ua/ETPhpq3jKURAvjFAKCRostmXhuC7Lc1euoeS0dlOw/F+wCcCihT
bWssHEKI2Ris5SObWcO2akw=
=P3f5
-----END PGP SIGNATURE-----

--=-AwbQr9n70mnrMO8J1oLM--

