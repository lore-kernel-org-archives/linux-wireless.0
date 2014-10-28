Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57140 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbaJ1OUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:20:33 -0400
Message-ID: <544FA627.3000004@rempel-privat.de> (sfid-20141028_152036_856290_FF01B973)
Date: Tue, 28 Oct 2014 15:20:23 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Etna <etna@openmailbox.org>, linux-wireless@vger.kernel.org
Subject: Re: MediaTek WiFi hardware support in upstream kernel
References: <544DB5A8.7090405@openmailbox.org> <20141027152026.GB19976@tuxdriver.com> <544E8CB4.3000607@rempel-privat.de> <20141028134608.GA26283@tuxdriver.com> <544FA303.5060303@broadcom.com>
In-Reply-To: <544FA303.5060303@broadcom.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cWqovaNA6kq0QWRx3c0TpvIaUBSND1c6G"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cWqovaNA6kq0QWRx3c0TpvIaUBSND1c6G
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 28.10.2014 um 15:06 schrieb Arend van Spriel:
> On 28-10-14 14:46, John W. Linville wrote:
>> On Mon, Oct 27, 2014 at 07:19:32PM +0100, Oleksij Rempel wrote:
>>> Am 27.10.2014 um 16:20 schrieb John W. Linville:
>>>> On Mon, Oct 27, 2014 at 11:02:00AM +0800, Etna wrote:
>>>>> I am not a developer, but I stumbled upon this just a couple of day=
s ago in
>>>>> the OpenWRT forums:
>>>>>
>>>>> https://forum.openwrt.org/viewtopic.php?id=3D53215
>>>>>
>>>>> In short, MediaTek is looking for volunteers to help get their driv=
ers
>>>>> mainlined in the upstream kernels; this includes drivers for their =
USB and
>>>>> PCI wifi hardware under both the MediaTek and Ralink brands. They a=
re
>>>>> willing to provide "chip info, reference driver, dev board, etc" an=
d even
>>>>> some degree of sponsorship, apparently subject to their management'=
s
>>>>> approval.
>>>>>
>>>>> In exchange, they require that the volunteers fulfill the following=

>>>>> requirements:
>>>>> - skilled in wifi driver development
>>>>> - provide a suitable schedule / roadmap
>>>>> - be able to get the code mainlined in the official linux kernel.
>>>>>
>>>>> Those who are keen on taking up the task can contact the original p=
oster at
>>>>> hua.shao[AT]mediatek.com
>>>>>
>>>>> **Disclaimer: I am in no way related to, or under the employ of Med=
iaTek or
>>>>> Ralink. I am only posting this here because I have a handful of MT =
wifi
>>>>> chips which I hope to see being supported in the upstream kernel so=
 that I
>>>>> can actually use them under Linux,
>>>>
>>>> Well, this is mostly good to see.  I hope there is someone that want=
s
>>>> to take-up the cause!
>>>>
>>>> If someone is interested in working-on the project above but for
>>>> whatever reason doesn't want to deal with MediaTek on their own,
>>>> feel free to contact me.  I'll try to be helpful however I can.
>>>>
>>>> Thanks,
>>>>
>>>> John
>>>
>>>
>>> Sounds interesting and as perfect possibility to learn. I would like =
to
>>> do it, but i have two concerns:
>>> - i never wrote an wifi driver from scratch.
>>
>> FWIW, I think MediaTek already has some form of drivers.  With that
>> said, it might be easier to write new mac80211-based ones than to
>> adapt the existing ones.
>>
>>> - i'm seeking for a job. It means if i will find one, this project wi=
ll
>>> get lower priority.
>>
>> No one can ask anything more.
>>
>>> If nobody has problems with this two points, then i'm ok.
>>
>> It sounds like we have a volunteer!  Let me know if you need any
>> specific help or guidance.
>=20
> During LPC Felix mentioned GPLed mediatek driver for their 11ac
> chipset(s?). It is on github:
>=20
> https://github.com/openwrt/mtk-wifi-gpl

What is the next step?

--=20
Regards,
Oleksij


--cWqovaNA6kq0QWRx3c0TpvIaUBSND1c6G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlRPpicACgkQHwImuRkmbWlbVwEAimBOpbk8bL8COAO27z6cTrZa
fA2ngrKpBlpoST/8dfUBAIYSFdYgMRmW6LIFlmXT7IM4TyN1iTGrtxVU/A00Au4Q
=U1pW
-----END PGP SIGNATURE-----

--cWqovaNA6kq0QWRx3c0TpvIaUBSND1c6G--
