Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbYILVwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 17:52:01 -0400
Subject: Re: [PATCH v3] mac80211: fix virtual interfaces vs. injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910809121450o5aaa9fe0m5b5d405be809362b@mail.gmail.com> (sfid-20080912_235012_004677_0482C848)
References: <1221172545.5956.7.camel@johannes.berg>
	 <1221173167.5956.16.camel@johannes.berg>
	 <1221231237.5576.2.camel@johannes.berg>
	 <1221252767.5576.25.camel@johannes.berg>
	 <69e28c910809121450o5aaa9fe0m5b5d405be809362b@mail.gmail.com>
	 (sfid-20080912_235012_004677_0482C848)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-b8ORT4cm1p+1inV9htHt"
Date: Fri, 12 Sep 2008 23:51:50 +0200
Message-Id: <1221256310.3700.0.camel@johannes.berg> (sfid-20080912_235205_488476_05D251F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-b8ORT4cm1p+1inV9htHt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-12 at 23:50 +0200, Stefanik G=C3=A1bor wrote:
> On Fri, Sep 12, 2008 at 10:52 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > +       /*
> > +        * Packet injection may want to control the sequence
> > +        * number
>=20
> Does this mean that this patch will allow for injecting frames with
> preset sequence numbers without requiring a (hostapd-breaking) patch?

If the driver properly honours mac80211's "please set sequence number"
control bit, yes. I don't think iwlwifi does, but b43 does.

johannes

--=-b8ORT4cm1p+1inV9htHt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyuRzAAoJEKVg1VMiehFYdVUP/3AGR8MR2tUBGyfDFJk1cTYd
QwG3TyPIDrV5ITPHrDlPPl/jAxqxE8pXMsYX/34+0GvM/+ZSYavPM8T1CpW+Azw1
DaM87AvilXEYEvrDUh/uUescyTAcfemT6GJ/HwQjRid3gLxJOsd01XoilNu3SfeD
aLfgq6M1PpYVcZ4pBxEDn8K0tL+Kj6gl2PrpFd9ubhkoTBXc3refjgZuiXSo7q4C
d61xiXYyUjZQsTnwb9NaQ3Pt+1a9p/gP6/wXedIOt2hskgp5p4PJ9JjHH5fCxsMY
cZUflQq0tEAzHY8wsvZJj4I52jziqKhIc55Zih6GX7ncJuhPO5SzezL8/ZXIZg2q
61wP0ywZRVK7WvDMq0xeIcp+xreYjgt/RjnOBT2aAQWafLQEbLu/Y1XO04ZtHK7k
R1TO6E/SDeyzM/eZCxZ/t2IZg2F0QZm0Esmj3byNH2bia8rEVAN+3oSi89QQgvHi
5CnFWvHtUalWCULLLPA9L0rbgJuQV2M8O+jhdyP6sXHlrOCn7hwthVio8so8/L/P
Yp94y9igea30bB+ue8Bpw6BvMOB2tm/YRmAkxPFSnEi7oDWEngq5l2UCW1kKiDD+
yXXEidQqYJVk0kxbJgbvQP3BgvsZKuAtlNQcun1ZaWHIWwo4dKXP1dVePF+O+7Ds
Zkb9wPDJPN95kgyRC8Zf
=WpdC
-----END PGP SIGNATURE-----

--=-b8ORT4cm1p+1inV9htHt--

