Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:23317 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaC3JuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2014 05:50:05 -0400
Message-ID: <5337E8B2.6030305@meshcoding.com> (sfid-20140330_115048_240797_3D30A88B)
Date: Sun, 30 Mar 2014 11:49:38 +0200
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
CC: Bob Copeland <me@bobcopeland.com>,
	open80211s <devel@lists.open80211s.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: TR: [RFC] 802.11s bitrate correction in airtime metric calculation
References: <773DB8A82AB6A046AE0195C68612A31901734186@sbs2003.acksys.local> <773DB8A82AB6A046AE0195C68612A31901734187@sbs2003.acksys.local> <20140328132204.GB18560@localhost> <5336D767.7050304@meshcoding.com> <CAHNKnsSWBLhjsbByPz4hG5M2YY7AtG6qtEaXDnQF2W+ts1Qr2g@mail.gmail.com>
In-Reply-To: <CAHNKnsSWBLhjsbByPz4hG5M2YY7AtG6qtEaXDnQF2W+ts1Qr2g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SjSdrsrO19qXtOj13A7nG7UR80AI1N42U"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SjSdrsrO19qXtOj13A7nG7UR80AI1N42U
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 29/03/14 19:43, Sergey Ryazanov wrote:
> Seems that this could be useful even for end user if we export these
> data via NL80211, since last_tx_rate is quite meaningless when using
> minstrel rate control.
>=20

Yeah, this was the second part of the RFC: export the expected
throughput via get_station() and then export get_station() as well so
that also other kernel modules out of mac80211 can use this estimation
(i.e. batman-adv in my case).

Cheers,

--=20
Antonio Quartulli


--SjSdrsrO19qXtOj13A7nG7UR80AI1N42U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTN+i2AAoJEEKTMo6mOh1VbLEP/iaXBmGYenefeJs4d/dNx590
roFPQuQibZ11grwhdP4isjEcjB5D0tA70rLorvkxD7yRu2Zkw08bDco9DZOOQrnb
XLpbJ8TWj61dlZHQLr/Cq3yl+y8Br7nDl2H1pIUQiKxKhbmjMbdD0/T7y0lMTCze
PWXT6GzCe/tZuf86JD+7magQad4UHsD8RF6DL8H/9XrMieTMAQojFCV+fN+8ZymA
4Wyc1l5fZ0tXTWWKtfcoLumeAm4BdNaBdgSNXcujfxn+ov27vJ8RLBXer3DGSr2f
iKfuaRsYyXMTHlfLjhJMzX90BbMpcL+XvGM+rkFr/71RY/1H1+Qhy+9xbZVp2cFw
0xpoTti3Eodmzc3b4IU5EYwHPHRqvBZ9eI2xeC8z2HBxMzUCyxXaQk+1rSypNO+B
gehza5F+m3yLbyS4VG7fchBkn7b5h0sR+h6gJKnf4bm7uxAENZUmYHfsNlZtDSzE
wABH9omVGBemyJLSmOcdbVz1PlqhJF4RjjUaaV+Z4hdOfl614Q1kXYkDrOq2jhJY
rPq4mP/lQWJ5k4Z5+eesQf0+HROr0JohbI+oXRO7cqehhqKK2rc8Cua0yAZh4wd8
dotp7ggJ5JZZbdOn9ekW8PSmlfV+AZlB3/aEPuGcVTJmn/uk1CuK6xNUv2KLEgqP
EFri5QlP5tYZwGriKV3V
=wvO2
-----END PGP SIGNATURE-----

--SjSdrsrO19qXtOj13A7nG7UR80AI1N42U--
