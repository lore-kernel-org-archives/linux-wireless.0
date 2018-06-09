Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:38481 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753256AbeFITrS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Jun 2018 15:47:18 -0400
Subject: Re: b43 crashes on rmmod (bcm4331)
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc: b43-dev@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
 <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
 <20180609171159.59b5209c@wiggum>
From: Wirz <spam@lukas-wirz.de>
Message-ID: <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de> (sfid-20180609_215150_527989_30E6C97D)
Date: Sat, 9 Jun 2018 22:46:58 +0300
MIME-Version: 1.0
In-Reply-To: <20180609171159.59b5209c@wiggum>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="OQqRreG8JhetddKTvaxji886eqbYiKRf6"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OQqRreG8JhetddKTvaxji886eqbYiKRf6
Content-Type: multipart/mixed; boundary="Tzc7mwIQp31cy1Vhj6bHTwps0wGRjzDdI";
 protected-headers="v1"
From: Wirz <spam@lukas-wirz.de>
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc: b43-dev@lists.infradead.org,
 linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de>
Subject: Re: b43 crashes on rmmod (bcm4331)
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
 <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
 <20180609171159.59b5209c@wiggum>
In-Reply-To: <20180609171159.59b5209c@wiggum>

--Tzc7mwIQp31cy1Vhj6bHTwps0wGRjzDdI
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Michael,

On 09/06/18 18:11, Michael B=C3=BCsch wrote:
> On Sat, 9 Jun 2018 15:08:24 +0300
> Wirz <spam@lukas-wirz.de> wrote:
>=20
>> The regression I reported a few weeks ago for 4.15, exists also in 4.1=
6.
>>  That is, with a bcm4331/ht-phy b43 can be loaded and used without
>> problems, but the driver crashes when it gets unloaded (making a hard
>> reset of the machine necessary).  This problem has been introduced
>> between 4.14 and 4.15.
>=20
> Thanks for your report.
>=20
> I just checked the diff between 4.14 and 4.15 for b43 and bcma. It's
> pretty small and there's no obvious candidate to me that could cause
> such a regression.
> This might be a change outside of b43 and bcma that triggered this
> behavior.
>=20
> Is is possible for you to create a git bisect to find the change that
> actually broke this?
> That would be really helpful.

I can try that.  What is the most efficient way to unload/recompile/load
a single module without rebooting the machine too often?  And it'll be a
lot of hard resets ...

cheers, lukas

--=20
Do not believe the naysayers who say it cannot be done.


--Tzc7mwIQp31cy1Vhj6bHTwps0wGRjzDdI--

--OQqRreG8JhetddKTvaxji886eqbYiKRf6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQfsLWbEt//FEFwBMDWbaSYbwIjLQUCWxwusgAKCRDWbaSYbwIj
LbOnAKCSZ7ICQuHaLP0dzIS13QM5R31jyACfXiTXa2sKRWuRu+EJnS3bO2gRC4E=
=RFnl
-----END PGP SIGNATURE-----

--OQqRreG8JhetddKTvaxji886eqbYiKRf6--
