Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762125AbZFJVFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 17:05:36 -0400
Subject: Re: [PATCH] mac80211: disassociate when switching bands and not
 scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"j@w1.fi" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1244667817.20900.402.camel@rc-desk>
References: <1244666131-20031-1-git-send-email-lrodriguez@atheros.com>
	 <1244666973.20900.399.camel@rc-desk>
	 <43e72e890906101349t502e9022h16fa79ea512f8b4d@mail.gmail.com>
	 <1244667817.20900.402.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-w+z+uQ6gXHCibjIZ+OpV"
Date: Wed, 10 Jun 2009 23:06:12 +0200
Message-Id: <1244667972.4706.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-w+z+uQ6gXHCibjIZ+OpV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-10 at 14:03 -0700, reinette chatre wrote:

> > > This touches code targeted for removal in recent "mac80211: disconnec=
t
> > > when user changes channel" patch.
> >=20
> > Heh I don't see that patch yet but if it exists that should fix this
> > too unless that patch didn't deauth/disassoc. Did you try with it
> > applied by any chance? I can't seem to find that patch on the list.
>=20
> That patch does seem to have same intention as yours. It is still RFC so
> I am not sure about its status. I did not test with it, but will do so.
> The patch can be found at
> http://marc.info/?l=3Dlinux-wireless&m=3D124458448631186&w=3D2

I'm waiting for a reply on the bug report (2015). Unfortunately, the bug
report is complicated by the hang issue so I'm not sure, will probably
post this patch for inclusion soon unless somebody objects.

johannes

--=-w+z+uQ6gXHCibjIZ+OpV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKMCA9AAoJEODzc/N7+QmauTEQAIQLYu6y5ybni9gDQcichyJG
CGyNmbd1VxuMWkIpdPptC2bpSsyaDAgIxrL36O2+pK3UmTb8Ec9sGBqnbZ5DwYn1
EDhKcQk9jiu5fH7vPEMfGDd/0fpdzv0h2Z2tBOsgsxaGz6XH0m3qr1yCmAfRtqBW
04wLQVCOGgdVXljD+22qs1/dr9W3UWSvcOH3cxq+ItZ03hcAOLsmTZdRCdyF6L/A
5baMBh3SltTJ9Q9EKMYU484pm+ALMWjaLNUMnM9m8gscUmag0ORU3kOrLOzXZR8v
x+L6/Vc8CObwY67qW9pLi7J8jq2yzOMryJ+uqS7GRUIG3939+yZeOl4SAxphbOPf
2QUicPO/WF83psZcSl7vdq48i4z3NzP8X4jSRIns61w7h1cKXuGB4wuY5hZWWAjM
9z9QwlpRj8MqzTGr7mYowhukDNowNRtTIFaeJ9RKi0lRM+MJB33zH96d+m5uhdOZ
/Hca1fCUIJt7fKHB2CaUqCMfPqLa+PBOnGPL3aESnslzuASFxh15um6+w6Fs45i6
Mjs6oK6yD8drftC6prXty95Q44yJ5oJsve7milBK41uUaj1UoYG+1MWKJIB1cw8T
j0/32+/x7zipCGHKuTfygRFPLMM0Z14EdONt28coJe+ZSjw0dNe0sb9iDSzXgCeT
vEieDu8s+jMJL94cmI/5
=zJCX
-----END PGP SIGNATURE-----

--=-w+z+uQ6gXHCibjIZ+OpV--

