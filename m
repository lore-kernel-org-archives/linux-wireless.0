Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbXFXJfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2007 05:35:05 -0400
Subject: Re: [PATCH Try#14 1/4] mac80211: Monitor mode radiotap injection  docs
From: Johannes Berg <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20070624090144.845936552@warmcat.com>
References: <20070624085757.244871712@warmcat.com>
	 <20070624090144.845936552@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VXmki/ITfB8ysW0U95Zi"
Date: Sun, 24 Jun 2007 11:36:32 +0200
Message-Id: <1182677792.21939.130.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VXmki/ITfB8ysW0U95Zi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-06-24 at 09:57 +0100, andy@warmcat.com wrote:
> plain text document attachment (mac80211-docs-radiotap-usage.patch)
> Try #14
>  - Documented Jiri Benc's injection encapsulation method

I still don't see the point since we've previously established that it
won't help on other interfaces (qdiscs, ...); for monitor interfaces #13
is enough and much simpler.

I'd vote for applying #13.

johannes

--=-VXmki/ITfB8ysW0U95Zi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGfjsg/ETPhpq3jKURAv7rAKCZFuWbYhNeUolP+0RBiZ6bms3KbgCgg3Xf
3lwAweq5T4mUNCSMyJCv7TQ=
=DmBC
-----END PGP SIGNATURE-----

--=-VXmki/ITfB8ysW0U95Zi--

