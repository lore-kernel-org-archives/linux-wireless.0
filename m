Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933864AbXCKRju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2007 13:39:50 -0400
Subject: Re: wireless extensions vs. 64-bit architectures
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Jouni Malinen <jkm@devicescape.com>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	Jeff Garzik <jgarzik@pobox.com>, Dan Williams <dcbw@redhat.com>
In-Reply-To: <20070309213531.GA28070@bougret.hpl.hp.com>
References: <20070306171316.GA19669@bougret.hpl.hp.com>
	 <200703061943.07350.mb@bu3sch.de>
	 <20070307020310.GA20466@bougret.hpl.hp.com>
	 <1173364747.14001.7.camel@johannes.berg>
	 <20070308184954.GA24485@bougret.hpl.hp.com>
	 <1173382042.3248.63.camel@johannes.berg>
	 <20070308193412.GG23040@devicescape.com>
	 <1173382802.3248.68.camel@johannes.berg>
	 <20070308221128.GA24884@bougret.hpl.hp.com>
	 <1173393326.3831.21.camel@johannes.berg>
	 <20070309213531.GA28070@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BAevytRqroPi/uMU7YYS"
Date: Sun, 11 Mar 2007 18:40:01 +0100
Message-Id: <1173634801.3382.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BAevytRqroPi/uMU7YYS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-09 at 13:35 -0800, Jean Tourrilhes wrote:

> 	It's not as bad as it look like. All userspace programs
> nowadays use either the iwlib or wpa_supplicant. For example,
> NetworkManager gets its stuff through wpa_supplicant, and kdenetwork
> uses iwlib. So, in essence, there is only two places to fix.

That's definitely not true, the latest network manager I have sources to
on my laptop right now (0.6.4) uses iwlib but only iw_get_ext and no
parsing functions. I would guess that others "use" iwlib like that too.

> 	By the way, I've just released version 29.pre16 which has a
> better band aid. It fixes bugs of the previous version and is more
> forward compatible (i.e. it's compatible with option 2).

Can you please also *document* the bandaid and actually *describe* it in
*words* instead of dense code without comments?

I'm still not convinced that papering over the problem in userspace is a
real solution.

johannes

--=-BAevytRqroPi/uMU7YYS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF9D7x/ETPhpq3jKURAublAJ9fHYUnh4T3Iq6P9Tf+xEv3V75HCQCfRn+f
eVHgiC5NSxVS0oFGdRlt2sA=
=9l22
-----END PGP SIGNATURE-----

--=-BAevytRqroPi/uMU7YYS--

