Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64890 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752526AbcK1Red (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 12:34:33 -0500
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
 <063b80df-9cfa-14f1-4695-4239b42dfccb@rempel-privat.de>
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
Message-ID: <217ac48f-d822-62d5-3def-744500821ac9@rempel-privat.de> (sfid-20161128_183438_000425_0B8E6456)
Date: Mon, 28 Nov 2016 18:33:56 +0100
MIME-Version: 1.0
In-Reply-To: <063b80df-9cfa-14f1-4695-4239b42dfccb@rempel-privat.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sDTgimvUScNJJjLqWkU7EXNQBKgNhV2MF"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sDTgimvUScNJJjLqWkU7EXNQBKgNhV2MF
Content-Type: multipart/mixed; boundary="hblsm19253Q6TQ2Er4NfmPM9v4tjWKqkf";
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
Message-ID: <217ac48f-d822-62d5-3def-744500821ac9@rempel-privat.de>
Subject: Re: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1478706966.18306.1.camel@sipsolutions.net>
 <2fcb5f28-808e-f296-7e91-e5185e7577c9@quantenna.com>
 <1478725543.21403.4.camel@sipsolutions.net>
 <d1cfaf8a-55a6-3a7c-9e9d-ec810fe5b80d@quantenna.com>
 <1478864146.4129.4.camel@sipsolutions.net>
 <ec6a249c-ef57-40d8-0cd2-31613f046e23@quantenna.com>
 <CANLJ0sm_iBfXB5TkjwTNO8RyYK3W7z8ecOrZo5f65qjb4WMXKQ@mail.gmail.com>
 <063b80df-9cfa-14f1-4695-4239b42dfccb@rempel-privat.de>
In-Reply-To: <063b80df-9cfa-14f1-4695-4239b42dfccb@rempel-privat.de>

--hblsm19253Q6TQ2Er4NfmPM9v4tjWKqkf
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 28.11.2016 um 18:10 schrieb Oleksij Rempel:
> Am 28.11.2016 um 17:34 schrieb Kyle McMartin:
>> On Tue, Nov 22, 2016 at 9:44 AM, IgorMitsyanko
>> <igor.mitsyanko.os@quantenna.com> wrote:
>>> Hi Ben, Kyle,
>>> could you please share what is the position of linux-firmware regardi=
ng
>>> firmware binaries that include GPL components? Does it require entire=
 GPL
>>> components codebase be present in linux-firmware tree, or maybe havin=
g this
>>> clause in license file is enough:
>>> +Open Source Software. The Software may include components that are l=
icensed
>>> +pursuant to open source software (=E2=80=9COpen Source Components=E2=
=80=9D). Information
>>> +regarding the Open Source Components included with the Software is
>>> available
>>> +upon request to oslegal@quantenna.com. To the extent such Open Sourc=
e
>>> +Components are required to be licensed to you under the terms of a s=
eparate
>>> +license (such as an open source license) then such other terms shall=
 apply,
>>> and
>>> +nothing herein shall be deemed or interpreted to limit any rights yo=
u may
>>> have
>>> +under any such applicable license.
>>>
>>> From technical perspective, size of the codebase used to build Quante=
nna
>>> firmware is a few hundred MBs, it seems too much to include into
>>> linux-firmware tree.
>>>
>>
>> I don't have strong feelings one way or another. I'd prefer not having=

>> several hundred
>> MB of source that's unlikely to change included in the linux-firmware
>> git tree. I'm also not
>> a lawyer, so I can't help you decide what would satisfy the
>> distribution clause of the GPLv2.
>> We already have one GPL firmware (carl9170fw) which includes the
>> source, but just references
>> a seperate toolchain for downloading, so it's only approximately 1MB
>> in size in the tree.
>>
>> Is your firmware source really that large, or is it just including the=

>> entire build toolchain with it?
>>
>> regards,
>> --Kyle
>=20
> We also have open BSD licensed open-ath9k-htc-firmware. Which is locate=

> out of source too.
> https://github.com/qca/open-ath9k-htc-firmware
> and here is location of carl firmware:
> https://github.com/chunkeey/carl9170fw
>=20
> So, what is actual problem with Quantenna QSR10G FW?
> I would be really interesting to take a look on it. Is it somewhere
> available? Are there some devices to get hand on?

After seeing specs of this device i have strong feeling that "some open
source part" is actual linux kernel.


--=20
Regards,
Oleksij


--hblsm19253Q6TQ2Er4NfmPM9v4tjWKqkf--

--sDTgimvUScNJJjLqWkU7EXNQBKgNhV2MF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlg8aoQACgkQHwImuRkmbWnfowEAl/tohZvisJZ5CJNDhk356lEm
r7TkydwXyE07HxdhsFsA/RPveXORTXA01JRFm5drRKRRGmy6/5cF5gYQGODvKfNN
=okW5
-----END PGP SIGNATURE-----

--sDTgimvUScNJJjLqWkU7EXNQBKgNhV2MF--
