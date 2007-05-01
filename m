Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:39692 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161761AbXEAS5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 14:57:32 -0400
Message-ID: <46378D83.7020706@web.de>
Date: Tue, 01 May 2007 20:57:07 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Jiri Benc <jbenc@suse.cz>,
	Johannes Berg <johannes@sipsolutions.net>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: d80211: How does TX flow control work?
References: <459A5945.80909@web.de> <46374C4C.50106@web.de> <20070501172513.2519f64b@logostar.upir.cz> <200705011301.24478.flamingice@sourmilk.net>
In-Reply-To: <200705011301.24478.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE8507218054685F9E919A027"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE8507218054685F9E919A027
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael Wu wrote:
> On Tuesday 01 May 2007 11:25, Jiri Benc wrote:
>> On Tue, 01 May 2007 16:18:52 +0200, Jan Kiszka wrote:
>>> Already tried this lethal command? Works "fine" here...
>>>
>>> #tc qdisc del dev wmaster0 root
>> I cannot reproduce it too.
>>
> I can reproduce it.

Fine, that save /me some time.

> I thought qdiscs couldn't be changed without taking the=20
> interface down first.. which is not true. It merely waits for things to=
 quiet=20
> down before swapping out the qdisc.
>=20
> Some code in ieee80211_master_start_xmit probably will be needed to cor=
rectly=20
> handle things if the ieee80211 qdisc isn't installed. I don't see an ea=
sy way=20
> to prevent things from working all the time if the qdisc is removed.

I didn't followed the discussion in details, but wasn't there once a
suggestion to hide netdevices from the user so that there would be no
chance to stumble over this issue?

Jan


--------------enigE8507218054685F9E919A027
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGN42LniDOoMHTA+kRApcbAJ9okOhWfwRRHu88w4CYN5HrilSQWQCfYlbM
5gfDWVaJidZPKz3P+T3BLH8=
=5yI6
-----END PGP SIGNATURE-----

--------------enigE8507218054685F9E919A027--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
