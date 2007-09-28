Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbXI1PGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 11:06:55 -0400
Subject: Re: 802.11n drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Patrick Ziegler <patrick.ziegler@fh-kl.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46FCF7E7.6080706@fh-kl.de>
References: <46FCF7E7.6080706@fh-kl.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6YZkASmxQ4uCNoOxaHg+"
Date: Fri, 28 Sep 2007 17:03:29 +0200
Message-Id: <1190991810.3907.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6YZkASmxQ4uCNoOxaHg+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-28 at 14:47 +0200, Patrick Ziegler wrote:

> we are working with new 802.11n Hardware. Is there a driver for some
> kinds of Hardware yet?

Intel has a driver for their 4965 chipset and reverse engineering/driver
projects for the airgo chipset are in progress.

>  Especially for Broadcom chipsets ( bcm2055 ) so
> called "Intensi-fi" ?

No, we haven't done that yet. "2055" is the Broadcom 802.11n radio chip,
the actual device is still identified as bcm43xx. I'm interested in
doing the necessary reverse engineering but I don't currently have any
hardware.

johannes

--=-6YZkASmxQ4uCNoOxaHg+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG/RfB/ETPhpq3jKURAifjAJ94bpTooJeeGDXwb7lNmM0YSLATrQCeIO4X
kpPQSRjalw55m4FwMH9b/iA=
=0ota
-----END PGP SIGNATURE-----

--=-6YZkASmxQ4uCNoOxaHg+--

