Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51977 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbaLDKJE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 05:09:04 -0500
Message-ID: <548032A5.4070706@rempel-privat.de> (sfid-20141204_110914_113601_D9F2495F)
Date: Thu, 04 Dec 2014 11:08:37 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: parthsane@laer.in
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"driverdev-devel@linuxdriverproject.org"
	<driverdev-devel@linuxdriverproject.org>,
	Larry Finger <larry.finger@lwfinger.net>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Ralink 6570 / Mediatek MT7601STA (was Re: Addition of a wifi
 kernel module to the linux source tree)
References: <CAD-4tLW3cvGrw3MYiLQni7OMJYGa=QJbrk_q9=9P2QuBb1EVFg@mail.gmail.com>	<CA+55aFw6zo4rTsEEX5uQe+8zeNR87JzmM8T=wYW7jvrHZPjB8A@mail.gmail.com>	<20141129191601.GA1234@kroah.com>	<CAD-4tLXYVtKJMWYW6cQ9aCL6rusUx3YpWSHys4xcTRN_dJ+kOA@mail.gmail.com>	<20141130184615.GA3122@kroah.com>	<CAD-4tLU-3otYOTO98s359z80SSbTJbiSstAYijiU__ekOPJkOA@mail.gmail.com>	<20141204012407.GA31191@kroah.com>	<CAD-4tLVrOqiUX2V9_VWMBbnFT-qEsO=zQF4qejd_N2H=scb4aw@mail.gmail.com>	<20141204043945.GA22144@kroah.com>	<CAGRGNgXiAAcFoUJyJiC2=yi7LGAU-=6L=NZpJxNj3V4E74RxCw@mail.gmail.com>	<20141204082348.GA1989@redhat.com>	<54802031.7010709@rempel-privat.de> <CAD-4tLWoLO8=NXnzuV8eHXcW5WDeS-Wv8uTvw=uiWEdDa9HKHg@mail.gmail.com>
In-Reply-To: <CAD-4tLWoLO8=NXnzuV8eHXcW5WDeS-Wv8uTvw=uiWEdDa9HKHg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uTk91ALO86pnhHKim8g7ktvhQlicGme6c"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uTk91ALO86pnhHKim8g7ktvhQlicGme6c
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 04.12.2014 um 10:26 schrieb Parth Sane:
> Hi,
> Guys I'll be using my other account on my private domain laer.in now
> onwards. Be sure to add me in your contacts. My new email is
> parthsane@laer.in
> -Parth
>=20
> On 4 December 2014 at 14:19, Oleksij Rempel <linux@rempel-privat.de> wr=
ote:
>> Am 04.12.2014 um 09:23 schrieb Stanislaw Gruszka:
>>> On Thu, Dec 04, 2014 at 03:52:52PM +1100, Julian Calaby wrote:
>>>> On Thu, Dec 4, 2014 at 3:39 PM, Greg Kroah-Hartman
>>>> <gregkh@linuxfoundation.org> wrote:
>>>>> On Thu, Dec 04, 2014 at 07:07:58AM +0530, Parth Sane wrote:
>>>>>> Hi,
>>>>>> I'd say I'm midway through with c programming(part of my computer
>>>>>> engineering degree course) and know a decent amount of git. So yes=
 I'm
>>>>>> comfortable writing code.
>>>>>
>>>>> Ok great, let's see if it's just a matter of some changes to the
>>>>> existing kernel driver before we decide to add the whole huge tarba=
ll
>>>>> to the staging tree as fixing it up will be a lot of work.
>>>>
>>>> I believe some people (CC'd) may have been working on / had an
>>>> interest in writing such a driver. I'm not sure what the status of
>>>> that effort is though.
>>>
>>> Right. Felix is working on new linux friendly driver for new Mediatek=

>>> chips.
>>
>> So far i know, Felix is working on abgn+ac (MT7662 and MT7612) devices=
=2E
>> MT7601STA is (a)bgn. Are there similar regs?
>>
>> In mt7601 code i see parts like "if (IS_RT3290(pAd) || IS_RT65XX(pAd) =
||
>> IS_MT7601(pAd))".  RT3290 is supported by rt2x00.

Am 04.12.2014 um 10:54 schrieb parthsane@laer.in:> Hi again,
> Please note my new email parthsane@laer.in . Also If you guys don't kno=
w
> there's a working source supplied by mediatek for mt7601. Please find
> the attached tarball. Also please apply this patch I mentioned about
> earlier. It's at https://gist.github.com/Boggartfly/b18bd86b8eb60fabe16=
0
>
> rt_linux.h has the following path in the driver directory.
>
> /include/os/rt_linux.h
>
> After you replace the patched file everything works and compiles
> successfully!! Any pointers on what should be done to make it kernel
> compatible?

Well, there is no kernel compatible part in this driver. With other
words it should be completely rewritten or cleaned up. As match as
possible of existing kernel code should be reused.

PS. please keep the topic.

--=20
Regards,
Oleksij


--uTk91ALO86pnhHKim8g7ktvhQlicGme6c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlSAMqUACgkQHwImuRkmbWnfNAEAgRnKyuHwcfSOUBA9xmeWGBug
w02lLNtGPHU+KuXFK3gBAJZua3U1e+XGUPtXx51Qg9yHUtDA0pVN5Xzfli0TkuMo
=gk+7
-----END PGP SIGNATURE-----

--uTk91ALO86pnhHKim8g7ktvhQlicGme6c--
