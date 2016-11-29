Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63684 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754638AbcK2Du1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 22:50:27 -0500
Subject: Re: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
To: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>,
        Kyle McMartin <kyle@mcmartin.ca>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1478706966.18306.1.camel@sipsolutions.net>
 <2fcb5f28-808e-f296-7e91-e5185e7577c9@quantenna.com>
 <1478725543.21403.4.camel@sipsolutions.net>
 <d1cfaf8a-55a6-3a7c-9e9d-ec810fe5b80d@quantenna.com>
 <1478864146.4129.4.camel@sipsolutions.net>
 <ec6a249c-ef57-40d8-0cd2-31613f046e23@quantenna.com>
 <CANLJ0sm_iBfXB5TkjwTNO8RyYK3W7z8ecOrZo5f65qjb4WMXKQ@mail.gmail.com>
 <063b80df-9cfa-14f1-4695-4239b42dfccb@rempel-privat.de>
 <217ac48f-d822-62d5-3def-744500821ac9@rempel-privat.de>
 <f4bf1f6a-6f5a-ea85-0835-c6805afdcd04@quantenna.com>
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
Message-ID: <ad7935a1-735b-706a-9ac1-cd5076d8f307@rempel-privat.de> (sfid-20161129_045035_033726_1A23B268)
Date: Tue, 29 Nov 2016 04:49:45 +0100
MIME-Version: 1.0
In-Reply-To: <f4bf1f6a-6f5a-ea85-0835-c6805afdcd04@quantenna.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ECsOAWx8unLpnSe5WpDRH0BErHjgjVEuG"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ECsOAWx8unLpnSe5WpDRH0BErHjgjVEuG
Content-Type: multipart/mixed; boundary="G7foiEsFL6Gx4IFaeLDVlMoCLq30BhNRM";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>,
 Kyle McMartin <kyle@mcmartin.ca>
Cc: Ben Hutchings <ben@decadent.org.uk>, Kyle McMartin <kyle@kernel.org>,
 Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
 btherthala@quantenna.com, hwang@quantenna.com, smaksimenko@quantenna.com,
 dlebed@quantenna.com, Igor Mitsyanko <imitsyanko@quantenna.com>,
 Kamlesh Rath <krath@quantenna.com>,
 Sergey Matyukevich <smatyukevich@quantenna.com>,
 Avinash Patil <avinashp@quantenna.com>
Message-ID: <ad7935a1-735b-706a-9ac1-cd5076d8f307@rempel-privat.de>
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
 <217ac48f-d822-62d5-3def-744500821ac9@rempel-privat.de>
 <f4bf1f6a-6f5a-ea85-0835-c6805afdcd04@quantenna.com>
In-Reply-To: <f4bf1f6a-6f5a-ea85-0835-c6805afdcd04@quantenna.com>

--G7foiEsFL6Gx4IFaeLDVlMoCLq30BhNRM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 28.11.2016 um 20:01 schrieb IgorMitsyanko:
> On 11/28/2016 08:33 PM, Oleksij Rempel wrote:
>> Am 28.11.2016 um 18:10 schrieb Oleksij Rempel:
>>> Am 28.11.2016 um 17:34 schrieb Kyle McMartin:
>>>> On Tue, Nov 22, 2016 at 9:44 AM, IgorMitsyanko
>>>> <igor.mitsyanko.os@quantenna.com> wrote:
>>>>> Hi Ben, Kyle,
>>>>> could you please share what is the position of linux-firmware
>>>>> regarding
>>>>> firmware binaries that include GPL components? Does it require
>>>>> entire GPL
>>>>> components codebase be present in linux-firmware tree, or maybe
>>>>> having this
>>>>> clause in license file is enough:
>>>>> +Open Source Software. The Software may include components that are=

>>>>> licensed
>>>>> +pursuant to open source software (=E2=80=9COpen Source Components=E2=
=80=9D).
>>>>> Information
>>>>> +regarding the Open Source Components included with the Software is=

>>>>> available
>>>>> +upon request to oslegal@quantenna.com. To the extent such Open Sou=
rce
>>>>> +Components are required to be licensed to you under the terms of a=

>>>>> separate
>>>>> +license (such as an open source license) then such other terms
>>>>> shall apply,
>>>>> and
>>>>> +nothing herein shall be deemed or interpreted to limit any rights
>>>>> you may
>>>>> have
>>>>> +under any such applicable license.
>>>>>
>>>>>  From technical perspective, size of the codebase used to build
>>>>> Quantenna
>>>>> firmware is a few hundred MBs, it seems too much to include into
>>>>> linux-firmware tree.
>>>>>
>>>> I don't have strong feelings one way or another. I'd prefer not havi=
ng
>>>> several hundred
>>>> MB of source that's unlikely to change included in the linux-firmwar=
e
>>>> git tree. I'm also not
>>>> a lawyer, so I can't help you decide what would satisfy the
>>>> distribution clause of the GPLv2.
>>>> We already have one GPL firmware (carl9170fw) which includes the
>>>> source, but just references
>>>> a seperate toolchain for downloading, so it's only approximately 1MB=

>>>> in size in the tree.
>>>>
>>>> Is your firmware source really that large, or is it just including t=
he
>>>> entire build toolchain with it?
>>>>
>>>> regards,
>>>> --Kyle
>>> We also have open BSD licensed open-ath9k-htc-firmware. Which is loca=
te
>>> out of source too.
>>> https://github.com/qca/open-ath9k-htc-firmware
>>> and here is location of carl firmware:
>>> https://github.com/chunkeey/carl9170fw
>>>
>>> So, what is actual problem with Quantenna QSR10G FW?
>>> I would be really interesting to take a look on it. Is it somewhere
>>> available? Are there some devices to get hand on?
>> After seeing specs of this device i have strong feeling that "some ope=
n
>> source part" is actual linux kernel.
>>
>>
> Oleksij, yes, that's correct, it includes entire Linux environment; the=

> reasoning is that it allows to hide all WiFi-related logic inside devic=
e
> itself, and emulate simple Ethernet device for external system
> (therefore, freeing external system resources).
>=20
> This approach was working really well for us until recently, but now
> that company is expanding, we want to have more flexible and standardiz=
e
> interface available for external system to manage wireless connection,
> and FullMAC driver seems to be the best solution here.

you mean, this driver will not use mac80211 framework provided by kernel?=


> For the availability of FW sources, QSR10G-based products are still
> under development at this moment (not in the market yet), but many
> products based on previous generation chipset QSR1000 are available. Fo=
r
> example, Asus has a retail design with QSR1000 chipset, and has all GPL=

> sourcecode available on their website (including what Quantenna has
> provided):
>=20
> http://www.asus.com/Networking/RTAC87U/HelpDesk_Download/
> Quantenna provided code is in, for example, "GPL of ASUS RT-AC87U for
> firmware 3.0.0.4.378.7410" archive.
> It's basically the same as used for QSR10G.

Will Quantenna provide documentation for at least old chipsats? Playing
fair with OSS developer community has some advantages :)


--=20
Regards,
Oleksij


--G7foiEsFL6Gx4IFaeLDVlMoCLq30BhNRM--

--ECsOAWx8unLpnSe5WpDRH0BErHjgjVEuG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlg8+ucACgkQHwImuRkmbWkNKQD9F+OqG9k3LwLYSYTyiCtMBjU/
QAzR5tGTEbC0dYF2+aQA/2GL8fA93cbrm+HLwrNDQ7It/h0ELMhMZ0QzwpbVG5es
=2f6w
-----END PGP SIGNATURE-----

--ECsOAWx8unLpnSe5WpDRH0BErHjgjVEuG--
