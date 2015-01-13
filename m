Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:50771 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbbAMHLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 02:11:55 -0500
Received: by mail-wg0-f53.google.com with SMTP id x13so1110721wgg.12
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 23:11:54 -0800 (PST)
Message-ID: <54B4C507.1030102@open-mesh.com> (sfid-20150113_081158_887232_8D810038)
Date: Tue, 13 Jan 2015 08:11:03 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath10k: fw_stats not reporting peer_stats with 10.2
References: <5492CFF5.9060107@open-mesh.com> <CA+BoTQm1H9jAszUH_gQCjcEk-GCQG0r9r7Jb2VdpM1CQF7jXeg@mail.gmail.com>
In-Reply-To: <CA+BoTQm1H9jAszUH_gQCjcEk-GCQG0r9r7Jb2VdpM1CQF7jXeg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SfPJnV8AxjQwDn3ub0C0L3GhEPo05FrbC"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SfPJnV8AxjQwDn3ub0C0L3GhEPo05FrbC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/01/15 12:54, Michal Kazior wrote:
> On 18 December 2014 at 14:00, Antonio Quartulli <antonio@open-mesh.com>=
 wrote:
>> I tried printing some debug messages here and there and the only usefu=
l
>> information I got is that in "ath10k_wmi_10x_pull_fw_stats()" the valu=
e
>> of "ev->num_peer_stats" is always 0.
>>
>> Is this yet another fw limitation?
>=20
> Firmware stats has a very fragile ABI. Apparently 10.2 changed it
> again and thus is broken. I'll try to look into it more if time
> permits.

Thank Micha=C5=82!
I will be happy to test any change you might be able to provide.

Cheers,


--=20
Antonio Quartulli


--SfPJnV8AxjQwDn3ub0C0L3GhEPo05FrbC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUtMUOAAoJEJgn97Bh2u9epwsQAKoKbrBq3FgmGy35F45JqCSh
KZ/pYNx0ilflVMAUDr6v0SDYoYcGEHZcW+gliLtagbjx8H6lgqCl6tB4uGSHNyUQ
fYPtzx32mMEQB4f2VjXAONvdb8DzQHXzqd6wUDRHBHOgYL65TSLSG8qzvkQixwwU
KxOM3rAq8hYlt8kgFTiczyIpLdxoo6LIo0wXko+erYTY9wRIQTVLyYbhf8Mct/cH
MjDjmX31AlmtbigBwOZLbNIbjIkwG8oJfzRycGb24pwZya5XOLDOBoDLaKRyOSHl
Lp/oSz6IqyoBSh+Kr6NwiWVHLBIW05LT9g+klIadE4VK8S6OoZxvIitDn1QWHgt/
77KRwFzyj6v+eCJbe5XGlGUNfoYJ+UeK/rxCLHdZtxDx/d4LB1SHxoaHH6tfPcUF
YOIDUUL+Eq1IUeIh6WRzD2ryL3861Pc/9DDo/CWgohUl8+Jp8VV1bTe2Dc1bxGGh
OuyIrgy6r1Kf0zyM343j8zgO5HNpFyXndAzyPtn5jSuGONlWLYqCTgQqtT5BwQSL
XWyQS5+Q62B53ek9RvJQN4FMJMmbfFVR1B+faByv1orBXNxqKSOplMf8rnGMCmKW
QY0Mk8w2OIPOmx91IkI3X7/uF/GkobwWwQ34ZdR+n15RnZlZF/earz3kj6VPykIS
O5z7QlxaTi/aT5oleHwd
=fb4b
-----END PGP SIGNATURE-----

--SfPJnV8AxjQwDn3ub0C0L3GhEPo05FrbC--
