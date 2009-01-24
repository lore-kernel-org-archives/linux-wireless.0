Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53205 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893AbZAXWOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 17:14:40 -0500
Subject: Re: [PATCH] mac80211: Generic TSF debugging
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <20090124203836.GC22475@tesla>
References: <20090124060959.50440@gmx.net>
	 <1232806359.4036.3.camel@johannes.local>
	 <1232807228.4036.12.camel@johannes.local>  <20090124203836.GC22475@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QHAtlDQnYY3+I7sYgJyW"
Date: Sat, 24 Jan 2009 23:14:33 +0100
Message-Id: <1232835273.4619.0.camel@johannes.local> (sfid-20090124_231457_215865_5DD3AD20)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QHAtlDQnYY3+I7sYgJyW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-24 at 12:38 -0800, Luis R. Rodriguez wrote:
> On Sat, Jan 24, 2009 at 06:27:08AM -0800, Johannes Berg wrote:
> > On Sat, 2009-01-24 at 15:12 +0100, Johannes Berg wrote:
> > > On Sat, 2009-01-24 at 07:09 +0100, Alina Friedrichsen wrote:
> > > > This patch enables low-level driver independent debugging of the TS=
F
> > > > and remove the driver specific things of ath5k and ath9k from the
> > > > debugfs.
> > >=20
> > > NACK.
> > >=20
> > > You still haven't explained why you need set_tsf support and why it
> > > should be a generic mac80211 functionality.
> >=20
> > Ok, I guess you have, I'm still not sure it's the best approach.
> >=20
> > Other opinions?
>=20
> Seems reasonable to me instead of having different drivers implement diff=
erent
> APIs/debugfs solutions.

Ok, since get_tsf is mostly debugging too, maybe it doesn't matter.
Let's go with this then, I'll make the kernel-doc a little clearer
later.

johannes

--=-QHAtlDQnYY3+I7sYgJyW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJe5LGAAoJEKVg1VMiehFY2+wP/AsoEa8hy024oEYoM/nqxqZX
mFZdm8fdFWz0Ct9Rx9Sp51VmzhO39wIqdUcRkWiQ5Zhi1u7AzH8CzPB1DCPf794j
lHeOSJNzKbLe003MarOxKSti8ttVioAOeVINe1Xc/Hcl+R0+vloXd9m2YJFbRJD1
aH4RaRN7GucH22faRBSMOODKWqCObu5RH8sWqxx19/1MHN3HFzUm+VmAgRvR1kXR
F5hhR/taiUtGf8f9UiqHSu9SF4ewKAvYTFegGjfQr3YJCTV4sPVOlbgrcsx1NPHj
R4DN235PYkISwGlmXp+ZGC36zqePZm36svU0sDu84thz7nAJ8zfES8I6RqFCDjlF
8x5fIGQ1+VplH5R70HpGXRH4wbEy15izDgXHQ6O2Jotmgw/9r4InzxZ26OAuaXL0
jP7nhI/1A1xmQWs0OqpVQVMO8aNsyDlDO8U9pDDAjexN9jgE5Y9rAHAXXQNOgE7o
vRGcVleJfbNw00PZb2CotO2aK3JjE2fSS5jedgY+TZip4lsGH64iUa4AfgGe7Csg
ezOxfN/dMyuqiexTD9bn1dLJIE4gDhWcBG2/PbhpkSM6I1gcQEkMH0DBdphUfKcH
a8xK/6ZwXGTlm1T2IB4NywkeKGDUxHGdOJLMcpo5s1F7L6LMM5u1V2Pv4GCDaE2j
dPZaNiNJiRutQDzBPDZ7
=RMzg
-----END PGP SIGNATURE-----

--=-QHAtlDQnYY3+I7sYgJyW--

