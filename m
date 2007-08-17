Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49923 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758078AbXHQKN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 06:13:28 -0400
Subject: Re: Kernel BUG when using ad-hoc mode in rt2x00
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Baker <linux@baker-net.org.uk>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200708162243.05809.linux@baker-net.org.uk>
References: <200708082324.17186.linux@baker-net.org.uk>
	 <200708161625.44057.linux@baker-net.org.uk>
	 <1187278509.23489.24.camel@johannes.berg>
	 <200708162243.05809.linux@baker-net.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yaWBpqk15iy0pbb7My4J"
Date: Fri, 17 Aug 2007 12:13:37 +0200
Message-Id: <1187345617.23489.143.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yaWBpqk15iy0pbb7My4J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-16 at 22:43 +0100, Adam Baker wrote:

> Having now managed to capture a small relevant area it looks like
> there were a couple of seconds missing from the end of that log file.

> [16697.856499] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.f=
lags 1746
> [16697.864492] INFO: trying to register non-stat

Hm. Maybe you could disable verbose debugging in the ralink drivers to
get a lower printk rate; however, this is weird, I think I'll have to
try to reproduce it.

johannes

--=-yaWBpqk15iy0pbb7My4J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxXTR/ETPhpq3jKURAnHGAJsHJ6ZG0OWeKaguj15LLMSfAyuAJwCgmtuz
uNgBJOCLBEhsr8S5I5LgE8w=
=P5ns
-----END PGP SIGNATURE-----

--=-yaWBpqk15iy0pbb7My4J--

