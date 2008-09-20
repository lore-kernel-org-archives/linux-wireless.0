Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43285 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbYITVNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 17:13:18 -0400
Subject: Re: [PATCH] b43: Fix Bluetooth coexistence SPROM coding error for
	Motorola 7010 variant of BCM4306
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <48D56659.5060209@lwfinger.net>
References: <48d401da.Q+F4HRESoxeIVa3r%Larry.Finger@lwfinger.net>
	 <200809201744.55571.mb@bu3sch.de>
	 (sfid-20080920_174550_869772_E28C99C2) <1221943895.3023.1.camel@johannes.berg>
	 <48D56659.5060209@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZJqJzdsDp/Vx3q0tV3BJ"
Date: Sat, 20 Sep 2008 23:13:09 +0200
Message-Id: <1221945189.3023.17.camel@johannes.berg> (sfid-20080920_231320_922548_BE4AA0DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZJqJzdsDp/Vx3q0tV3BJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-20 at 16:08 -0500, Larry Finger wrote:

> I don't know, but I really wouldn't want to blindly kill bluetooth
> coexistence. After all, most cards have their SPROMs programmed
> correctly. Only the PCI-versions of the BCM4306 and the ASUS BCM4318
> seem to have the problem.

Yeah, true, it's mostly fine. Maybe we're missing something in the specs
that makes the original driver work? Otherwise, I suspect they'd be
getting these cards back in bunches...

> I have been working the openSUSE and Ubuntu support forums, which is
> where I have been getting these new devices to add to the work-around.

Yeah, I still wonder where you get the patience to deal with support
forums, but I think everybody very much appreciates that :)

johannes

--=-ZJqJzdsDp/Vx3q0tV3BJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI1WdhAAoJEKVg1VMiehFYIWMP/j2ZyiUuPxFnPzzLt6cXqvNK
umZ2D1xwgRrLzj81nRxTenoRxHrFmPyqSTBcZVFblmoJiAkYWRBBjqoG2o1CG349
/1nzq/LWKhYuXzBWHyFhlCGHhj8VIaS5GJS6EODXlf4pGuNc4D2dyA49oIlVUdEi
zwWXo3n2NePqG8b303bw/o2KbkJQNcFFOzQHcl/3ZRCDP2hq2Sak/SCJVVXhnZ7B
Yfz45WcDC9pwBxeoDEuD/EQTCGqV2tg3NtQcOj6vuYqK/ZsKfJgIP3/UWlW39Mbz
bz6DAeufXYJaJpbACkeFLifclq1ClOm5++syGQlUjaF5TcuK+9IMVQPKEDwEJbSo
m2WA834a0KEXJRW4sdSWAWAVoZj49HMxosN2dg79QAjI9xZjxdw4+gk91ipaldty
WnUewLqs4pKf5dN1cMUReTrrgt83MVxVC50q3zz9AnOVabOEo77uYFl+XwakQyuP
CAN1TWq/thRFUV2+ck698X06IeTxZyheIIsdl2ERV/tcenNKbRyvZKCifV+z7kMe
MydYxTpqoy8Wahhc7KpaqohGDLDXb7FN2I6qRKSqVj09YMGZhRUC/8zCVQZG1CoL
7Wd16WSeb/AT2Caa3YaPoWzjirLi84LbOOr+ybcdDhGViiHCAEHHrostyh6pb8tF
szt6zm1NteyhJgxfZ/ps
=4ZNq
-----END PGP SIGNATURE-----

--=-ZJqJzdsDp/Vx3q0tV3BJ--

