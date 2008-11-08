Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35759 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbYKHNLd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 08:11:33 -0500
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
In-Reply-To: <491589ED.4090904@hotmail.com>
References: <4902DEBB.3050205@hotmail.com>
	 <20081025112147.GA12252@Chamillionaire.breakpoint.cc>
	 <200810251325.07916.mb@bu3sch.de>
	 <20081025112813.GC12252@Chamillionaire.breakpoint.cc>
	 <49033782.5040701@hotmail.com>  <491589ED.4090904@hotmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Sg3EVOGP1QUcAgzho+Xg"
Date: Sat, 08 Nov 2008 14:11:34 +0100
Message-Id: <1226149894.3610.8.camel@johannes.berg> (sfid-20081108_141137_279626_35F751EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Sg3EVOGP1QUcAgzho+Xg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-08 at 23:45 +1100, Shaddy Baddah wrote:

> > [  179.249516] zd1211rw 4-3:1.0: zd_usb_rfwrite() value 0x01e6666 bits =
24
> > [  179.254524] wlan0: Initial auth_alg=3D0
> > [  179.254549] wlan0: authenticate with AP XX:XX:XX:XX:XX:XX
> > [  179.256215] Kernel unaligned access at TPC[10129b94]=20
> > zd_mac_rx+0x174/0x320 [zd1211rw]
> > [  179.349135] Kernel unaligned access at TPC[10129b9c]=20
> > zd_mac_rx+0x17c/0x320 [zd1211rw]
> > [  179.442852] Kernel unaligned access at TPC[10129ba0]=20
> > zd_mac_rx+0x180/0x320 [zd1211rw]
> > [  179.536579] Kernel unaligned access at TPC[10129ba4]=20
> > zd_mac_rx+0x184/0x320 [zd1211rw]
> > [  179.630306] Kernel unaligned access at TPC[10129ba8]=20
> > zd_mac_rx+0x188/0x320 [zd1211rw]
>=20
> I'm keen on troubleshooting this myself. Could you please tell me how I=20
> can get a disassembly intermixed with source. An objdump -S ./zd1211rw.o=20
> is not doing the job. I'd rather not re-compile the whole kernel if=20
> possible, because it takes long. Should I rm the file, do a build, take=20
> the command line and substitute -g for any -O option?

I usually just _add_ -g3 to the command line I get with make V=3D1 M=3D...

johannes

--=-Sg3EVOGP1QUcAgzho+Xg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFZACAAoJEKVg1VMiehFY7nMP/jF/oje87LOWYtcFjKALphzG
j/pP2pUg4t/uEdMDAFbGuAP1Dws1CEACQzWZ9ChJGVxShk2mQ3jdOfMkw4Jl/NaD
DtzseO5xVrhVwNQvOzg4GBe5LkCeWnDUCWrCf7CuT82LAHOqw4Lf0V78/jZYfI/A
GlTKP77b3zgPB0q4pkrDI+YtGx3HNsehzMvdZYQxCslqo4YAV+LMD1h/Hf92tqP3
Ee4EshYN7GVg1OUtrIpdHGoSw1UOjZwOwJj0nnVrsmnGklfFx4eEapzS4jlGn9SU
4x36mhXRWcCmvWaww/NiTjO0MpDSkHVidKTGrL9z2IoaCivPbGyEs8KJ92BGXWYX
4s8oddfS4/mupVuRGBo7hltGyPjObm9SdXxP47BtcF2QFNq4S4lbbgnpdCeW/h23
G1dDxZcmaTPAxCK1S83OQBvifC8IGw7/CdCRqBEMlz2c3FwRb28RXDt3ibbrBYaq
rHU7o52txXSwNmYQ22CsdcLN2xYHU2pPbgsV1LbTCRL/IR8pQzzpbwRvASbgUV5d
6Q6SSM24uRYcVr0jWUZzT2vC9l9ftRhZCKps021G7/izKM+pDucs11iKwb3P7eOm
hnEraEkYvGR1JDtA/PO03VDUFe5YPWZJ12d8rTptQflyqu18GkBOkePKx9YRx6l1
ZqBE+wnvFAGj45vs7WvJ
=Y8nP
-----END PGP SIGNATURE-----

--=-Sg3EVOGP1QUcAgzho+Xg--

