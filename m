Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbXHUKRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 06:17:12 -0400
Subject: Re: [PATCH V3] mac80211: Turn off meaningless TKIP message when  software WEP encryption is used
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Larry Finger <larry.finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Mattias Nissler <mattias.nissler@gmx.de>
In-Reply-To: <200708201955.46232.IvDoorn@gmail.com>
References: <46c0d788.GYQYqGfCBKyAWrg7%Larry.Finger@lwfinger.net>
	 <46C0E5AD.2080407@lwfinger.net>
	 <200708131658.27758.flamingice@sourmilk.net>
	 <200708201955.46232.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nPWlYfugbiWtq+5OgoJv"
Date: Tue, 21 Aug 2007 12:17:02 +0200
Message-Id: <1187691422.4288.9.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nPWlYfugbiWtq+5OgoJv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-20 at 19:55 +0200, Ivo van Doorn wrote:

> Has this behavior changed recently?
> e.g. Has a patch been sent recently which will correctly enforce the rule=
 mentioned
> above, but has not yet appeared in wireless-dev?

No, it's still in my patchset. The semantics of that flag are rather
unclear so I've cleaned it up completely. However, key selection is
broken anyway at the moment so multicast/broadcast isn't coming through
on software crypto.

johannes

--=-nPWlYfugbiWtq+5OgoJv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyrue/ETPhpq3jKURAlATAJ49v65GSM4OvYWP05b4w8S7HRCCUgCfcCPE
INU1adhAYVE3We03ukKbs0g=
=9g4o
-----END PGP SIGNATURE-----

--=-nPWlYfugbiWtq+5OgoJv--

