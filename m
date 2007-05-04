Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:52294 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031435AbXEDRXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2007 13:23:12 -0400
Message-ID: <463B6BB9.2050701@web.de>
Date: Fri, 04 May 2007 19:22:01 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: don't break without 802.11 qdisc
References: <20070504014159.3ed9d594@logostar.upir.cz>
In-Reply-To: <20070504014159.3ed9d594@logostar.upir.cz>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2F8B426DEAA4574C306A7EAA"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2F8B426DEAA4574C306A7EAA
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Jiri Benc wrote:
> Jan, could you test if this patch fixes your problems with removing of
> 802.11 qdisc? (It applies on top of the patch
> http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-dev.git;a=
=3Dcommitdiff_plain;h=3D00a908826e778b39a802013729f7826c2d575360 )

Depends on how we define "fix": I'm still able to tweak the qdisc of
wmaster0 (and so will shorewall). That may or may not lead to some BUG
(WARN_ON) of the 80211 stack later on as it used to, I need to watch a
bit longer.

What should be the effect of the patch? Catch, revert, or even prevent
this qdisc change of a shutdown and/or running wlan device?

Jan


--------------enig2F8B426DEAA4574C306A7EAA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGO2u5niDOoMHTA+kRAja9AJ9Y1kkKNn3oYFh51A8ABE8xPnqjPACdE1Zk
rC9XDFyr1bqHUko4/q22NOI=
=Tern
-----END PGP SIGNATURE-----

--------------enig2F8B426DEAA4574C306A7EAA--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
