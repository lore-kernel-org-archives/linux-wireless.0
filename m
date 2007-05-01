Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:36688 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423569AbXEAOTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 10:19:05 -0400
Message-ID: <46374C4C.50106@web.de>
Date: Tue, 01 May 2007 16:18:52 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jiri Benc <jbenc@suse.cz>, Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: d80211: How does TX flow control work?
References: <459A5945.80909@web.de>	 <20070103185203.2754e059@griffin.suse.cz>	<459BF179.6000906@web.de>	 <20070103191853.4f440b8b@griffin.suse.cz>	<459BFB05.9040608@web.de>	 <45A03825.9080807@web.de>	<45A2A728.1070404@web.de>	 <1175029130.5151.6.camel@johannes.berg>	<460B7CAA.4020604@web.de>	 <4637195E.5050907@web.de> <20070501124733.47c45dd0@logostar.upir.cz>	 <46371B71.2090508@web.de> <1178017466.3483.20.camel@johannes.berg>	 <46373B94.4080307@web.de> <1178026008.4157.0.camel@johannes.berg>
In-Reply-To: <1178026008.4157.0.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEA5830B3B5FC75905C8B75C2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEA5830B3B5FC75905C8B75C2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Johannes Berg wrote:
> On Tue, 2007-05-01 at 15:07 +0200, Jan Kiszka wrote:
>> Johannes Berg wrote:
>>> On Tue, 2007-05-01 at 12:50 +0200, Jan Kiszka wrote:
>>>
>>>> Could you point me to the patch(es) in question? I only have 2MBit/s=

>>>> downlink, so that downloading only the patch would speed things up h=
ere.
>>> http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-dev.git=
;a=3Dcommit;h=3D00a908826e778b39a802013729f7826c2d575360
>>>
>> Nope, doesn't help. And I wonder how this piece should do so: It just
>> performs a sanity check on ifconfig up, right? But the "tc qdisc del"
>> runs here _after_ wlan0 got configured.
>=20
> I never managed to reproduce that part anyway. I hadn't tried removing
> the qdisc when the device is down, but when it's up I never managed
> to... odd
>=20

Already tried this lethal command? Works "fine" here...

#tc qdisc del dev wmaster0 root

Jan


--------------enigEA5830B3B5FC75905C8B75C2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGN0xMniDOoMHTA+kRAoJkAJ9GNJP8AgIQK71BFPusTEVzGsYIQQCfaKeo
5R5YyRCpiCO0J5YzC/qmLjs=
=FA4d
-----END PGP SIGNATURE-----

--------------enigEA5830B3B5FC75905C8B75C2--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
