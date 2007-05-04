Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:60761 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031029AbXEDTFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2007 15:05:36 -0400
Message-ID: <463B83EE.6080801@web.de>
Date: Fri, 04 May 2007 21:05:18 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: don't break without 802.11 qdisc
References: <20070504014159.3ed9d594@logostar.upir.cz> <463B6BB9.2050701@web.de> <200705041343.19369.flamingice@sourmilk.net>
In-Reply-To: <200705041343.19369.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDBC98C720F20F4E4975737B1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDBC98C720F20F4E4975737B1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael Wu wrote:
> On Friday 04 May 2007 13:22, Jan Kiszka wrote:
>> What should be the effect of the patch? Catch, revert, or even prevent=

>> this qdisc change of a shutdown and/or running wlan device?
>>
> It merely makes it so that it is safe to not use the ieee80211 qdisc.

So I would just run my device(s) in a suboptimal mode from that point on?=


Is it possible to establish the deleted qdisc again? tc tells me
"ieee80211" is an unknown discipline. Well, this still sounds a bit...
suboptimal.

Jan


--------------enigDBC98C720F20F4E4975737B1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGO4PuniDOoMHTA+kRAoewAJ9KSWhz/IPEVIZBQ26xKAQXTrZWFgCgg6hX
BE7cQVUyQC6DDI6bq/APSx0=
=MJ3k
-----END PGP SIGNATURE-----

--------------enigDBC98C720F20F4E4975737B1--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
