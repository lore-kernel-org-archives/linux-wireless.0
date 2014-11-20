Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:35221 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbaKTUqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 15:46:30 -0500
Message-ID: <546E5323.6070603@telenet.be> (sfid-20141120_214635_143097_2747F6C2)
Date: Thu, 20 Nov 2014 21:46:27 +0100
From: Ruben De Smet <ruben.de.smet@telenet.be>
MIME-Version: 1.0
To: Francesco Gringoli <francesco.gringoli@gmail.com>,
	=?UTF-8?B?UmFmYcWC?= =?UTF-8?B?IE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: Broadcom Corporation BCM43228 802.11a/b/g/n
References: <546DE1DB.7090900@telenet.be> <CACna6rzHG+mrTWq55ALSsya+bM7hOuqcwDq0Y-sHcxdHEHphqQ@mail.gmail.com> <DE52984E-3492-4EAC-9CFA-736EE76922EA@unibs.it>
In-Reply-To: <DE52984E-3492-4EAC-9CFA-736EE76922EA@unibs.it>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Ot1fTn35ln6tM7GTwnrRidx9M1jDTT4GL"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ot1fTn35ln6tM7GTwnrRidx9M1jDTT4GL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 20-11-14 15:49, Francesco Gringoli wrote:
> On Nov 20, 2014, at 1:51 PM, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>=
 wrote:
>=20
>> On 20 November 2014 13:43, Ruben De Smet <ruben.de.smet@telenet.be> wr=
ote:
>>> This will be the last day I'm using my Broadcom Corporation BCM43228
>>> 802.11a/b/g/n miniPCI WiFi card, as I'm switching to a faster Intel A=
C card.
>>> Is there any interest in the linux-wireless or b43 community to have
>>> this device for reverse engineering purposes? I'm able to send it for=
 free.
>>
>> Did you test this device with b43? Were there any problems with it?
> By the way, I have been using a few 43228 in monitor mode with b43 and =
they were hanging pretty randomly (I was using 3.16.0-wl that time, appar=
ently they were stopping receiving but they were still able to transmit).=
 Although they work much better than 43224, especially with 48Mb/s and 54=
Mb/s and with higher MCS (especially with two streams), the 43224 seemed =
to be more stable.
>=20
> Best,
> -Francesco
>=20

Followup: just tried to place the new WLAN card in my notebook; Lenovo
doesn't like them if they're not whitelisted. I'll have to hack my bios
before I send this card over.

Yes, I tried blacklisting the proprietary wl on kernel 3.17 and
rebooting. Messed a bit around, I could scan for networks, but wasn't
able to connect to any of them. I sent a mail about that earlier to the
b43 list; got no response (possibly someone forgot to use reply all).

R


--Ot1fTn35ln6tM7GTwnrRidx9M1jDTT4GL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUblMkAAoJEPgmWogSE9wQ2PIH/iSP6dbtgF2UVl3OM3Ld2zSR
azJelVHdQtjrHwWHLjLJn+K6nBGHi1BMlqtvWN0rZVTFZUEL5zNokhuJDc8UiyQv
kenaEf6hdbSLyyTISgRERBtvxDAIpr2PO2mo1W/Dd88EU8eixh2vYliRDlzK+jLW
IGA9w1nEUyBZJglM8ek9qRof4lQZIMH4oH7SnRyKC0LHa9ehBqN901xmbMiKvo9U
3LOkNVDftFHvG1LdQGkRtoFQ58mB9NRdWbjTKl8QjjYi5zx3GMjPOdrgqWNRoOsF
dUQQzEBqtgziHx2Sa73dOzFZn+oGJNFl5My/1uGE5ds3CGkS03+oTVfezJ/maok=
=FfgA
-----END PGP SIGNATURE-----

--Ot1fTn35ln6tM7GTwnrRidx9M1jDTT4GL--
