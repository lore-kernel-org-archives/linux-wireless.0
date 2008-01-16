Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYAPQl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 11:41:58 -0500
Subject: Re: [RFC] mac80211: proper short-slot handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Michael Buesch <mb@bu3sch.de>,
	Michael Wu <flamingice@sourmilk.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	bruno randolf <br1@einfach.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Yanbo Li <dreamfly281@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <200801161737.00682.IvDoorn@gmail.com> (sfid-20080116_163722_467037_B4D8FD78)
References: <1199974496.3861.80.camel@johannes.berg>
	 <200801102000.44722.IvDoorn@gmail.com>
	 <1200490221.5887.170.camel@johannes.berg>
	 <200801161737.00682.IvDoorn@gmail.com>
	 (sfid-20080116_163722_467037_B4D8FD78)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AySxdagS3MvXDT2eKdDy"
Date: Wed, 16 Jan 2008 17:41:39 +0100
Message-Id: <1200501699.8708.9.camel@johannes.berg> (sfid-20080116_164201_880931_B2541023)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AySxdagS3MvXDT2eKdDy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> John already merged the 2.0.14 release into the everything branch,
> so no need to wait on that. The remaining patches which have been send
> but not yet merged are bugfixes which won't cause a collision with the
> short-slot patch.
>=20
> Not sure where I diffed it against, I probably have to rebase it anyway
> since I currently have a few major patches pending for the 2.1.0 release
> which will drastically change the entire interface handling in rt2x00.

Ok.

> When do you plan to send the patch for inclusion? I can rebase the patch
> and make it part of the 2.1.0 release of this weekend or release 2.1.0
> and rebase the patch against that.

I don't know. I haven't seen anybody but You and Tomas agree with this
patch. I can try to convert the other drivers but I'm not sure when I'll
manage to do that.

johannes

--=-AySxdagS3MvXDT2eKdDy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR44zwaVg1VMiehFYAQIIaBAAko0DFE0xdPdz4fdR7qb5TUiEN6dB25eG
X18BC2KZkC1p9+1u7mIczCJXFIr9UvGBaTjCDh3S2OVUUwRFNmnwdB0oO3VSEW07
IdAiQ66wk2nuqKy8nRoLWL8fSvhq9+/I5gKuZwOrmjnWZzaXVlc3YlmZkOMyRn1i
z+6VmVxaDSPUrdTGLuUoQBQ+D99Oywa4DZzlAga4u5aqIqbIQ+9o/Q6olt34vZGz
plpBzUGRz1Q4ArmAuj2ctS74NbTfy6H7z0JWKqQvBPuKfOFNnPADMoKbaPRqefkW
BPEfkCDkNt4sL9AQssTi9+vGUUwalDcyEgZSE1zLEI13rdPVX7+chQDkdnuNd7EE
JI9Q00yzcEb6ejZfCXjipCHWbAXQ7rvv6UW/30/GIoJKlyCZQ8yu8FVjVYuP3lth
p3DK5SEf2oC2+nzsbvB88MBT89M+nYODdcwpSmQWG1b2i2zVaDrCKlydeyOb4sev
w2Od4R0BNe/9M5p+ODnkYcNy4qtuKD+ARdG8YlGMo5uQgeYAKePWXnUqYhJd7Oa4
dBnbMNylDMfINRmsrrnTdRTFa0Ucpo9H8s9BlDOW8b6HeS3mshc2GfOEZdkOXqG+
tWAre80BVIbRHCfcNqz19LKbWfG1rX55+WhuhEcwennq3RZ9r4X/VTsY345z2nzB
oWK+sBArDOM=
=/SVw
-----END PGP SIGNATURE-----

--=-AySxdagS3MvXDT2eKdDy--

