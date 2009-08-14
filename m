Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbZHNSK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 14:10:29 -0400
Subject: Re: Spare warnings - wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A859F52.1000608@gmail.com>
References: <43e72e890908131331q371320a3gf1ab53ea27574549@mail.gmail.com>
	 <4A859F52.1000608@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-v5KFZqRrarswyVcGuO9r"
Date: Fri, 14 Aug 2009 20:10:26 +0200
Message-Id: <1250273426.4411.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-v5KFZqRrarswyVcGuO9r
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-14 at 18:30 +0100, Dave wrote:

> I've been staring at setibssport for 5 minutes, and can't see the
> alleged imbalance. False positive?
>=20
> I can't see why sparse picked on setibssport either - half the other
> functions in that file do exactly the same.

Yeah, I've been there too -- no idea why that particular function trips
up sparse.

johannes

--=-v5KFZqRrarswyVcGuO9r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKhaiPAAoJEODzc/N7+QmaFzQP/jIWxxxJUG7u3+tgTiIK40ot
BbKD6cHM7W80hMn7tcLUMmhJ7G5+KqTSc/7fZyUj6OXq0FuzvDW1EcGIoW1McmVZ
BM1rue82eooCOXtCuY6/K5XU0HZQQYZHV4JA94hqB/2MIFgKvwymg9ktNNZT6iTR
UdPU9Wizpsnovus/K+K5G0REdlnWp1ZIUrCeP39hkWt+r5bzksDb4cppaJn0RukT
R1X1tHO/9cv5lzf+YWwxME8Z1YDamLwWxEaBlnBpCV1MKKgUz4K5TW+gaWtU32Mg
vI7HNOLKFzmrfnFVxfJhg1NKVz5cMMLcYmkkj13YKpJ6sL+2NyMN/hHYTl/cyjLl
/inmQP1sJ0R9wtLva818mXJCB+UDi3JvvCvirXF2YiZtblfxk1qy8TFNuByDTFI9
qISEuTlSeR+n60wZmj7jcajM6raPke/A9Ht6kUbygRB+aw4vUrGvYETG4lVSQHlv
DE4j0x9we3L6rwHbbrANbkYs/hgX+TjDIAESSaCzZGX+EWDhw0ABXxjPAd0WBj18
iOi+sIUu+tPBHF36KcVUQZOgeaTi3PAe5gYx+W/NN7YtL8qaveJFOOilwVpa2G/6
RAYRKbe/rKRsCMw35WuRKRZXxZ5u6lx7Sy5eelxhCgkUctUEExbYS9KBZntD64xv
AoP4SAmRQF0GSnZiTDki
=lvWE
-----END PGP SIGNATURE-----

--=-v5KFZqRrarswyVcGuO9r--

