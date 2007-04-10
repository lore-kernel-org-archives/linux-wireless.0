Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030346AbXDJFfe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2007 01:35:34 -0400
Subject: Re: [PATCH] mac80211: make mode change to same mode always  successful
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200704092245.49798.flamingice@sourmilk.net>
References: <200704092245.49798.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Jp3eecn8Ms3N4iNbTRnj"
Date: Tue, 10 Apr 2007 07:35:49 +0200
Message-Id: <1176183349.8459.55.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Jp3eecn8Ms3N4iNbTRnj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-04-09 at 22:45 -0400, Michael Wu wrote:
> I suspect wireless mode change failure is the cause of many wpa_supplican=
t and=20
> NM problems. Anyone who is having issues with wpa_supplicant and/or NM -=20
> please try this patch.

Haven't tried it yet, but it looks good to me. Not much point in denying
a change to a mode that we currently have. I don't really have issues
with wpa_supplicant though, it does print a lot of mode change failures
but never seems to care.

johannes

--=-Jp3eecn8Ms3N4iNbTRnj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGGyI1/ETPhpq3jKURAuU0AJ9qXKQwFwwBTNxey27zo6yk7qiI/QCeK9Ic
PP+3IqsgCIc1TBausDmjppw=
=WR+4
-----END PGP SIGNATURE-----

--=-Jp3eecn8Ms3N4iNbTRnj--

