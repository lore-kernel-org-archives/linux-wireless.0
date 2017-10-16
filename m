Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49419 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751776AbdJPGqx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 02:46:53 -0400
Subject: Re: Two rtlwifi drivers?
To: Pkshih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
 <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
 <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
 <87k202qcjr.fsf@kamboji.qca.qualcomm.com> <20171011131310.GF32250@kroah.com>
 <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com> <20171012103450.GA24647@kroah.com>
 <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <ed361ae7-864e-1179-c7da-3ff10f4c73e2@rempel-privat.de> (sfid-20171016_084701_758571_049FFD6E)
Date: Mon, 16 Oct 2017 08:46:10 +0200
MIME-Version: 1.0
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6EjQu5naqxdlE64PEb4ll3Q8q3naaWeJK"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6EjQu5naqxdlE64PEb4ll3Q8q3naaWeJK
Content-Type: multipart/mixed; boundary="wFX26CgQq8MOql8cewlx7Q9Gp2oNhrUjh";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Pkshih <pkshih@realtek.com>, Larry Finger <Larry.Finger@lwfinger.net>,
 Kalle Valo <kvalo@codeaurora.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, =?UTF-8?B?6I6K5b2l5a6j?=
 <yhchuang@realtek.com>, Johannes Berg <johannes.berg@intel.com>,
 Souptick Joarder <jrdr.linux@gmail.com>,
 "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Message-ID: <ed361ae7-864e-1179-c7da-3ff10f4c73e2@rempel-privat.de>
Subject: Re: Two rtlwifi drivers?
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
 <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
 <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
 <87k202qcjr.fsf@kamboji.qca.qualcomm.com> <20171011131310.GF32250@kroah.com>
 <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com> <20171012103450.GA24647@kroah.com>
 <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>

--wFX26CgQq8MOql8cewlx7Q9Gp2oNhrUjh
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi
Just my two cents, :)

Am 16.10.2017 um 04:41 schrieb Pkshih:
>=20
>=20
>> -----Original Message-----
>> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
>> Sent: Thursday, October 12, 2017 6:35 PM
>> To: Kalle Valo
>> Cc: Larry Finger; Dan Carpenter; Pkshih; =E8=8E=8A=E5=BD=A5=E5=AE=A3; =
Johannes Berg; Souptick Joarder;
>> devel@driverdev.osuosl.org; linux-wireless@vger.kernel.org; kernel-jan=
itors@vger.kernel.org
>> Subject: Re: Two rtlwifi drivers?
>>
>> On Thu, Oct 12, 2017 at 11:38:06AM +0300, Kalle Valo wrote:
>>>> So what to do?  Any ideas?  What makes your life easier?  You can ju=
st
>>>> ignore the staging tree, as it should not affect your portion of the=

>>>> kernel at all, right?
>>>
>>> Yes, I automatically ignore anything staging related. But the problem=
 is
>>> that we now have two drivers with the same name and people don't alwa=
ys
>>> remember to prefix the patch with "staging: ". So on a bad day I migh=
t
>>> accidentally apply a patch which was meant for your tree. Of course I=

>>> immediately revert it as soon as I, or someone else, catches that but=

>>> annoying still.
>>
>> It doesn't bother me if you apply staging patches, I can handle the
>> merge issues :)
>>
>>> I think we have two options here:
>>>
>>> 1) We set a deadline (like 12 months or something) for the
>>>    drivers/staging/rtlwifi and after that you refuse to take any patc=
hes
>>>    for it. Hopefully this makes it clear for everyone that this fork =
is
>>>    just temporary. I think Larry is trying to do this, which is great=
=2E
>>
>> Fine with me, if Larry is ok with it.
>>
>>> 2) We move the whole rtlwifi driver to staging. A very bad option but=

>>>    still better than forking the drivers.
>>
>> Ick, I don't want that to have to happen, that would not be good for t=
he
>> users of other devices that the "real" rtlwifi driver supports.
>>
>=20
> Hi Larry, Kalle and Gerg,
>=20
> This is Realtek engineer, PK. I appreciate your support to submit, revi=
ew=20
> and merge patch. Since I'm a Linux newbie, I'll describe the situation =
of=20
> rtlwifi and need your suggestions.
>=20
>=20
> 1) New modules in rtlwifi
>    We add two modules named phydm and halmac, when adding rtl8822be in =

>    staging. The phydm is BB/RF related module containing the parameters=

>    and APIs of BB/RF, and a dynamic mechanism to adapt to different
>    field environment. The halmac consists of MAC APIs.
>    The two modules are used by many OSs, so '#ifdef', CamelCase and
>    so on are existing in original files. Hence, we convert them to Linu=
x=20
>    form by script, but it's not perfect. Do you have suggestion to deal=

>    with this problem?
>=20
>=20
> 2) The rtlwifi in staging
>    In staging, the module phydm v13 contains bugs, so I want to upgrade=

>    to v21 (Realtek internal version number). This upgrade contains a
>    big patch that the difference between v13 and v21, and there are=20
>    40+ patches to support this upgrade. I have three options, and
>    I want to know which one is prefer.
>=20
> 2.1) apply 40+ patches to both staging and wireless tree, and apply
>      the big patch to staging only. After reviewing, we move the module=

>      to wireless tree.
>=20
> 2.2) apply 40+ patches to wireless tree, and apply a single bigger=20
>      patch containing 40+ patches and the big patch to staging. I think=

>      this can be seen as a new driver in staging. After reviewing,=20
>      we move the module to wireless tree.
>=20
> 2.3) don't apply anything to staging. Just apply 40+ patches and add
>      phydm v21 to wireless.
>=20
>=20
> 3) Coming drivers -- rtl8723de and rtl8821ce
>    We're developing the two drivers, and rtl8723de and rtl8821ce will
>    be ready on 2017Q4 and 2018Q1 respectively. The drivers are based on=

>    rtl8822be that in staging now, so the line of code will be fewer.
>    The new files will be a new IC folder and IC supported files of=20
>    three modules that btcoexist, phydm and halmac. Could I submit
>    them to wirless tree when they're ready?
>=20
>=20
> 4) As Kalle mentioned, rtlwifi contains many magic numbers, and I=20
>    plan to fix them after rtl8723de and rtl8821ce. Because the drivers
>    are developing, the changes will make us hard to integrate. However,=

>    I don't have plan to process the magic numbers in the module phydm,
>    because the most of BB/RF registers contain many functions. And
>    it doesn't have a register name but a bit field name instead.
>    Our BB team guys say the use of enumeration or defined name will
>    be unreadable, and the name is meaningless for most people.

Experience with ath9k driver showed, that development was kind of
balanced between two groups, QCA and Community (Other companies,
researches, education and so on.). Saying: "you will not understand it
any way" is nor really helpful :)
Please don't repeat bad experience of Broadcom.

> Many Linux users ask Larry about the new drivers, and Realtek will
> provide drivers and try to submit them by myself. I hope the Linux
> users can yield the drivers as soon as I can. On the way, I'll=20
> attend netdev workshop in Korea, so we can meet there if you attend too=
=2E

I hope to see Realtek providing patches and supporting Larry. Currently
RTL WiFi is taken by many user only if there is no other choice. So far
I would say:
1. provide testfarm and upstream patches - this will make reliable
driver and make most user happy.
2. provide documentation - this will make industrial and education
customers happy, so we will pay back with more patches.
3. make it interesting for WiFi hacker and your product will win!

--=20
Regards,
Oleksij


--wFX26CgQq8MOql8cewlx7Q9Gp2oNhrUjh--

--6EjQu5naqxdlE64PEb4ll3Q8q3naaWeJK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF4EAREIAAYFAlnkVbcACgkQHwImuRkmbWnM5wD7BRbqfpIoeghabJdKqnDf3tzV
wHpIFQ04x3NJKdk/vUMA/21sSlayNGCCDS82ggsoupvydfBdfhAa6WrbjV0GXw9b
=EJEx
-----END PGP SIGNATURE-----

--6EjQu5naqxdlE64PEb4ll3Q8q3naaWeJK--
