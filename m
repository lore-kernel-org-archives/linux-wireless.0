Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59501 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbZH0SWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 14:22:40 -0400
Subject: Re: [PATCH] iw: fix NL80211_STA_INFO_PLINK_STATE printing in
 station dump
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1251396920-3954-1-git-send-email-brian@cozybit.com>
References: <iw1>  <1251396920-3954-1-git-send-email-brian@cozybit.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Cy3Zbb8VkmaKxsE4LGo7"
Date: Thu, 27 Aug 2009 20:22:10 +0200
Message-Id: <1251397330.29084.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Cy3Zbb8VkmaKxsE4LGo7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-27 at 11:15 -0700, Brian Cavagnolo wrote:
> NL80211_STA_INFO_PLINK_STATE is a u8, not a u16.  This bug was causing
> unexpected output on big endian machines.

Applied, thanks.

johannes

--=-Cy3Zbb8VkmaKxsE4LGo7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKls7NAAoJEODzc/N7+QmaeogP/3Vn6kKci4YTcf5bJpl8SXh/
VFa4HiEs1dng3O+/kWUS6dwPqJVvIXOf7D9/SvrJmbe4WkRNt55CrLGBETDm2Eq/
3gKb4oBst7uWAh+1YEyHAELE5En9WkoB1bhTJEETUX9yoV4kZCOPZyyryDIpwpEG
nQgat25Yuk3QTNO44aV10DYS329WfAPi/EPadc5pgHjr2GS67voCwaa+8HDl9hPX
NKsN8Og3AnkL5CY7CrpEvW23b7Iy/2oeU1nHHSQPAWIhq3jpolZHL9EKPmJ0kyWx
qI6qmMNS62c/3NQZaVAsTVlqmBMjtyJv0+OhNR7LxqjUdKwhxYbIocAKz7vvGT6/
cXuyne8JI4rooGtngUBzP7E46cIuXI8BkaEQjkWb6+6/zDlmaMNYQmPrlYjwpYFY
wkywlN7fEhKUjgnAz7bECgd4Iua+5B0M1KMvymcM4rBOYVrPbVGG8zrbMHxTpE64
IOv3fVX3vDGjl/xamDQCv2PBC1MNLXoGRVM9nMNLF//1zGcTxkOP0z73SCyTYr1b
ZHAdPGfYIwzjwV6h/xm85N6PmolfaMl5vdFZU/HueUkB3BO6JXuioOKg8lHvbzcY
gfG7UhsdKZDE2DQ6o6+GSZG21dE37oUixDLG7FiospEsrWh2oEmTpefu8oeHPTtP
XMFQE+NPROGHKAlZrRhp
=fnI7
-----END PGP SIGNATURE-----

--=-Cy3Zbb8VkmaKxsE4LGo7--

