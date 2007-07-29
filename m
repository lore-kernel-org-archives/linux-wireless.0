Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from betty.cbit.net.au ([202.55.154.10]:43541 "EHLO mail.cbit.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759905AbXG2MSp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2007 08:18:45 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.cbit.net.au (Postfix) with ESMTP id 8D0F8108080
	for <linux-wireless@vger.kernel.org>; Sun, 29 Jul 2007 21:59:44 +1000 (EST)
Received: from mail.cbit.net.au ([127.0.0.1])
	by localhost (localhost [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id E9vZfqz-9wP4 for <linux-wireless@vger.kernel.org>;
	Sun, 29 Jul 2007 21:59:44 +1000 (EST)
Received: from keitarou.bubblesworth.net (unknown [202.55.155.86])
	by mail.cbit.net.au (Postfix) with ESMTP id 5C0E3108076
	for <linux-wireless@vger.kernel.org>; Sun, 29 Jul 2007 21:59:44 +1000 (EST)
Date: Sun, 29 Jul 2007 21:59:43 +1000
From: Paul TBBle Hampson <Paul.Hampson@Pobox.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx-mac80211: Fix specs typo for baseband attenuation
Message-ID: <20070729115943.GA12631@keitarou>
References: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net> <20070726172138.GA6068@tuxdriver.com> <46A8E044.6080206@lwfinger.net> <20070726181334.GB6068@tuxdriver.com> <46A8ECD6.30204@lwfinger.net> <1185527932.14697.535.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
In-Reply-To: <1185527932.14697.535.camel@pmac.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 27, 2007 at 10:18:52AM +0100, David Woodhouse wrote:
> I still get constant complaints of 'eth1: duplicate address detected'
> due to the fact that it sees its own outgoing packets, and IPv6 doesn't
> work.

Last time I looked at this, I believed it was a mac80211 issue since it
affected both the bcm43xx-mac80211 and dadwifi drivers, which otherwise
functioned fine, but didn't affect (the non-mac80211) bcm43xx driver.

--=20
-----------------------------------------------------------
Paul "TBBle" Hampson, B.Sc, LPI, MCSE
On-hiatus Asian Studies student, ANU
The Boss, Bubblesworth Pty Ltd (ABN: 51 095 284 361)
Paul.Hampson@Pobox.com

Of course Pacman didn't influence us as kids. If it did,
we'd be running around in darkened rooms, popping pills and
listening to repetitive music.
 -- Kristian Wilson, Nintendo, Inc, 1989

License: http://creativecommons.org/licenses/by/2.1/au/
-----------------------------------------------------------

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD4DBQFGrIEvexDuohKLFuARAhrDAKCGNhDGEM+YlYqGzCwi0tiT1NfZawCXd5e7
xWVoRL/7XcXR6f4R7XljjQ==
=L3/6
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
