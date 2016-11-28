Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52543 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932885AbcK1RLK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 12:11:10 -0500
Subject: Re: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
To: Kyle McMartin <kyle@mcmartin.ca>,
        IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1478706966.18306.1.camel@sipsolutions.net>
 <2fcb5f28-808e-f296-7e91-e5185e7577c9@quantenna.com>
 <1478725543.21403.4.camel@sipsolutions.net>
 <d1cfaf8a-55a6-3a7c-9e9d-ec810fe5b80d@quantenna.com>
 <1478864146.4129.4.camel@sipsolutions.net>
 <ec6a249c-ef57-40d8-0cd2-31613f046e23@quantenna.com>
 <CANLJ0sm_iBfXB5TkjwTNO8RyYK3W7z8ecOrZo5f65qjb4WMXKQ@mail.gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Kyle McMartin <kyle@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, btherthala@quantenna.com,
        hwang@quantenna.com, smaksimenko@quantenna.com,
        dlebed@quantenna.com, Igor Mitsyanko <imitsyanko@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <063b80df-9cfa-14f1-4695-4239b42dfccb@rempel-privat.de> (sfid-20161128_181117_621697_5813A4C4)
Date: Mon, 28 Nov 2016 18:10:47 +0100
MIME-Version: 1.0
In-Reply-To: <CANLJ0sm_iBfXB5TkjwTNO8RyYK3W7z8ecOrZo5f65qjb4WMXKQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oKVNpiWw6dA75Nnf29Q89P4UxNcMmo5Bb"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oKVNpiWw6dA75Nnf29Q89P4UxNcMmo5Bb
Content-Type: multipart/mixed; boundary="McD7mlFLKsdLhAja2FuQpsH07FtMTml5N";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Kyle McMartin <kyle@mcmartin.ca>,
 IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Kyle McMartin <kyle@kernel.org>,
 Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
 btherthala@quantenna.com, hwang@quantenna.com, smaksimenko@quantenna.com,
 dlebed@quantenna.com, Igor Mitsyanko <imitsyanko@quantenna.com>,
 Kamlesh Rath <krath@quantenna.com>,
 Sergey Matyukevich <smatyukevich@quantenna.com>,
 Avinash Patil <avinashp@quantenna.com>
Message-ID: <063b80df-9cfa-14f1-4695-4239b42dfccb@rempel-privat.de>
Subject: Re: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1478706966.18306.1.camel@sipsolutions.net>
 <2fcb5f28-808e-f296-7e91-e5185e7577c9@quantenna.com>
 <1478725543.21403.4.camel@sipsolutions.net>
 <d1cfaf8a-55a6-3a7c-9e9d-ec810fe5b80d@quantenna.com>
 <1478864146.4129.4.camel@sipsolutions.net>
 <ec6a249c-ef57-40d8-0cd2-31613f046e23@quantenna.com>
 <CANLJ0sm_iBfXB5TkjwTNO8RyYK3W7z8ecOrZo5f65qjb4WMXKQ@mail.gmail.com>
In-Reply-To: <CANLJ0sm_iBfXB5TkjwTNO8RyYK3W7z8ecOrZo5f65qjb4WMXKQ@mail.gmail.com>

--McD7mlFLKsdLhAja2FuQpsH07FtMTml5N
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 28.11.2016 um 17:34 schrieb Kyle McMartin:
> On Tue, Nov 22, 2016 at 9:44 AM, IgorMitsyanko
> <igor.mitsyanko.os@quantenna.com> wrote:
>> Hi Ben, Kyle,
>> could you please share what is the position of linux-firmware regardin=
g
>> firmware binaries that include GPL components? Does it require entire =
GPL
>> components codebase be present in linux-firmware tree, or maybe having=
 this
>> clause in license file is enough:
>> +Open Source Software. The Software may include components that are li=
censed
>> +pursuant to open source software (=E2=80=9COpen Source Components=E2=80=
=9D). Information
>> +regarding the Open Source Components included with the Software is
>> available
>> +upon request to oslegal@quantenna.com. To the extent such Open Source=

>> +Components are required to be licensed to you under the terms of a se=
parate
>> +license (such as an open source license) then such other terms shall =
apply,
>> and
>> +nothing herein shall be deemed or interpreted to limit any rights you=
 may
>> have
>> +under any such applicable license.
>>
>> From technical perspective, size of the codebase used to build Quanten=
na
>> firmware is a few hundred MBs, it seems too much to include into
>> linux-firmware tree.
>>
>=20
> I don't have strong feelings one way or another. I'd prefer not having
> several hundred
> MB of source that's unlikely to change included in the linux-firmware
> git tree. I'm also not
> a lawyer, so I can't help you decide what would satisfy the
> distribution clause of the GPLv2.
> We already have one GPL firmware (carl9170fw) which includes the
> source, but just references
> a seperate toolchain for downloading, so it's only approximately 1MB
> in size in the tree.
>=20
> Is your firmware source really that large, or is it just including the
> entire build toolchain with it?
>=20
> regards,
> --Kyle

We also have open BSD licensed open-ath9k-htc-firmware. Which is locate
out of source too.
https://github.com/qca/open-ath9k-htc-firmware
and here is location of carl firmware:
https://github.com/chunkeey/carl9170fw

So, what is actual problem with Quantenna QSR10G FW?
I would be really interesting to take a look on it. Is it somewhere
available? Are there some devices to get hand on?

--=20
Regards,
Oleksij


--McD7mlFLKsdLhAja2FuQpsH07FtMTml5N--

--oKVNpiWw6dA75Nnf29Q89P4UxNcMmo5Bb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlg8ZR4ACgkQHwImuRkmbWkf6AD/bEuTmvfB6z0dsWnX8JOw/G8h
EnHGaIZKhmTRn0o/SyoA/1r5sLNs5cIFIg7Evz3TF/wMUodYfndcADe+O++zUuDx
=Bggl
-----END PGP SIGNATURE-----

--oKVNpiWw6dA75Nnf29Q89P4UxNcMmo5Bb--
