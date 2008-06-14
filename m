Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45967 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbYFNJma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2008 05:42:30 -0400
Subject: Re: iwl3945 and WPA
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Maciek Kaliszewski <mkalkal@interia.pl>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080614093851.GF5062@jm.kir.nu> (sfid-20080614_113939_524119_3155082E)
References: <4852658A.4040402@interia.pl>
	 <20080613132317.GB5333@tuxdriver.com>
	 <1ba2fa240806130637u1f4b485dked28ce04ff52a9b5@mail.gmail.com>
	 <48527D72.4070509@interia.pl> <1213375014.29669.36.camel@dv>
	 <4852D6EB.3020304@interia.pl> <1213391287.22425.31.camel@dv>
	 <4852F389.1070506@interia.pl>  <20080614093851.GF5062@jm.kir.nu>
	 (sfid-20080614_113939_524119_3155082E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O7a1uSK+fOCCnLqc6C7m"
Date: Sat, 14 Jun 2008 11:42:03 +0200
Message-Id: <1213436523.3860.44.camel@johannes.berg> (sfid-20080614_114234_847393_9F83F100)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O7a1uSK+fOCCnLqc6C7m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > You are right . It may be wpa_supplicant issue . (I'm moving to hostap =
list=20
> > as soon as I get subscribed )
> > Kernel is amd64 and wpa_supplicant is i386 binary.
>=20
> Isn't this the known issue with ioctl compat code when using 64-bit
> kernel with 32-bit user space?=20

Yes.

> wireless-tools has some workaround code
> for figuring out what kernel is trying to say in WEXT data, but
> wpa_supplicant does not have such workaround since I do not believe it
> belongs to every user space program that is using WEXT.

I think only Jean disagrees.

> If I've understood correctly, Dave Miller is working on cleaning up the
> compat WEXT code (see "Proper compat WEXT support" thread from June 3rd
> for the patch series). I would hope that that fixes issues with
> 64/32-bit systems without require all user space programs to be modified
> to be aware of the bogus data from the kernel. As a temporary
> workaround, it might help to build 64-bit wpa_supplicant for that
> kernel.

Yeah, it should be in there. Building a 64-bit wpa supplicant is quite
hard unless you have all 64-bit libs already, so maybe it's easier to
apply Dave's patches.

johannes

--=-O7a1uSK+fOCCnLqc6C7m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIU5JnAAoJEKVg1VMiehFYkZcP/3/w4/066SfmuSYgXtSAhFQq
K+YNDa9bJtfrUA/3ORH7MrHZCeP5SKwzcH3h2zvOo8sCRmlBeA3sP9MCw3yZMJpj
xT7N/4oyRoPHxU4efe2MsTUZEo9llQyKd7ysn9PoUwUux0gY5cJ/a1hfHWNX6gYZ
SRN0elVDsGIwiuMMruHTBxDz7TmvrfbRWoz/te9q542il0RRkdPjXfiYepUJEeTa
wa0QeIt86EC6BQifFR9W5bzkbbJpkISlyNgvE+ewFrZNhb+EE092R0j0SRhkpCvt
0s+TioYEnWzhOR3iCBlvPKcCDI48z2TGdcylvjr9kygnx/Z74AncOO/xm56um5ws
G05lR82EpCuwkLcgknFOE/6TQF4wyuRdW/PRatGJHPHeexyC5GjnxkNgKvNf3Zbu
OiFcIj4yG1/bIRn1nWaFflAvKwU/eS7ooxjLEPU8oB25R79W3/p2j+AofKV/tKCM
eyT6HH8yJgT4QeVga+36wcP9YzvhDAR1X3eMuU3dMIf79pR9Mv+it5OfIB69fZ73
j4eBwBD7byWNqKHykXEdtdthausnk35jHxWkvXe5EWhMl8doIPijJeX6DBAWgSNv
BSh9U+ckvOT3VWrhl9QtR1r/pKSLW6rXJ7Xc1EW2F5fu9ctN1bpGYtGOEZPxnW+y
IMXCPrSWGqh0ntm/LYe7
=G99K
-----END PGP SIGNATURE-----

--=-O7a1uSK+fOCCnLqc6C7m--

