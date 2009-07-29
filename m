Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37246 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZG2HV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 03:21:56 -0400
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
From: Johannes Berg <johannes@sipsolutions.net>
To: chris2553@googlemail.com
Cc: Luis Correia <luis.f.correia@gmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <200907290803.46110.chris2553@googlemail.com>
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com>
	 <c6b1100b0907280634j4610d077rb30f1f571aac7f36@mail.gmail.com>
	 <efe7343f0907280638i12b0bb4bq237ca4f6376eb1fe@mail.gmail.com>
	 <200907290803.46110.chris2553@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-c93nGGrhfZ20y/ky5gYM"
Date: Wed, 29 Jul 2009 09:21:17 +0200
Message-Id: <1248852077.13742.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-c93nGGrhfZ20y/ky5gYM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-29 at 08:03 +0100, Chris Clayton wrote:

> 3. Once power-saving kicks in, the machine cannot be contacted from anoth=
er machine on the network -=20
> pings are not responded to, for example. Is this the intended behaviour?

No. The device is supposed to listen to beacons, check if there's
traffic pending and retrieve it. So sounds like a device problem unless
your AP is broken.

> 4. Are there any plans to be able to switch power-saving on/off on a driv=
er-by-driver basis. It=20
> seems to me, although I'm happy to be corrected, that it is either on or =
off for a given kernel,=20
> depending on CONFIG_MAC80211_DEFAULT_PS. But, if like me, someone has two=
 cards (one at home and one=20
> at work, for example), one that works fine with PS and one that doesn't, =
they have to set PS off=20
> for their kernel, or have two kernels. Could PS be {en,dis}abled by, say,=
 a module parameter or a=20
> sysfs switch?

iwconfig wlan0 power off

(yeah, looks weird, but power means "power saving")

johannes

--=-c93nGGrhfZ20y/ky5gYM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKb/hpAAoJEODzc/N7+Qma1tEQALsmujoOg7dggfZG0u+bg+nC
Q9GQXmOxe+trrZ+V6AiD3TnqRiHjyxnAM73bIvE4b6y4phzx3IIbOJgd64ysaTqx
wdqKpMOMr9hG5vea8FtMQyk8RQzb/esvDybcfURWQxIWsSgVtLseV6Y40BlaZLor
S97c+t2XRhMpMbnRrjP4zoXTTfFIQa7z0d1wJdgbP7A3Yy0c1GRi0RXXLcp0T7Fd
RvfxMPQWuJhSRynMSEZHvxg7MCtGYXy17Ywb2aMTjA1s/TLBgl2SnljYjM1mR79C
41n6BpiGRMWdHL+Dxi4LeYljjJYjOzfoSqljnU16ngIiweIno1LVVI67hshVJNs2
CeIBI8FICUOZR+fiHHN6VKjvY4llEzQNwfh3Ye1CLTwvbc9iMxym3oPHjn6mBLo5
el/9KCmZNOJ+un28/ImWE3OzUZJWK/fUeZcS/C1mokyc/KtWE++7TeOJO1oO6dia
+Y0I6QdEPe9iZ3h2/2bbMQDg0QFLYN8L4n3yGRa8eUSpHtbqLHQ29kL7gt9+0p+s
MXLBRUwzQc31v2ECVkXMidLX1kCgnQs8xSCpzGYiPIPq5proRXSfEOssabgK9vRv
zp7s1KQOlqYm5ZorLEwQwJCW4lrtGAnSXPC1LDYQxCqrWoeyTU6c30syjA8B4ba2
/VS627IzXakh14NY/SCo
=IOB0
-----END PGP SIGNATURE-----

--=-c93nGGrhfZ20y/ky5gYM--

