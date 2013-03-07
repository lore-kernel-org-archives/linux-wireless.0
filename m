Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:56670 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab3CGQff (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 11:35:35 -0500
Date: Thu, 7 Mar 2013 17:35:07 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 11/13] b43: HT-PHY: implement RSSI polling
Message-ID: <20130307173507.64a55ba3@milhouse> (sfid-20130307_173542_067171_EE4FC8A8)
In-Reply-To: <1362671247-10766-12-git-send-email-zajec5@gmail.com>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
	<1362671247-10766-12-git-send-email-zajec5@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Q7PpeNDyYP8_i5ip7mWfuAb"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/Q7PpeNDyYP8_i5ip7mWfuAb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  7 Mar 2013 16:47:25 +0100
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> +	const u16 ctl_regs[3][2] =3D {
> +		{ B43_PHY_HT_AFE_C1, B43_PHY_HT_AFE_C1_OVER, },
> +		{ B43_PHY_HT_AFE_C2, B43_PHY_HT_AFE_C2_OVER, },
> +		{ B43_PHY_HT_AFE_C3, B43_PHY_HT_AFE_C3_OVER, },
> +	};
> +	const u16 radio_r[] =3D { R2059_SYN, R2059_TXRX0, R2059_RXRX1, };

> +	u16 phy_regs_to_save[] =3D {
> +		B43_PHY_HT_AFE_C1, B43_PHY_HT_AFE_C1_OVER,
> +		0x848, 0x841,
> +		B43_PHY_HT_AFE_C2, B43_PHY_HT_AFE_C2_OVER,
> +		0x868, 0x861,
> +		B43_PHY_HT_AFE_C3, B43_PHY_HT_AFE_C3_OVER,
> +		0x888, 0x881,
> +	};

It usually is better to define tables that are constant as "static const",
so that they are not put on the kernel stack.

--=20
Michael

--Sig_/Q7PpeNDyYP8_i5ip7mWfuAb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJROMG7AAoJEPUyvh2QjYsOg8cQANyUHmtATGorJmo+1BHN4Bf7
4rk/WdBdhkkAxELwsx6sGpEgsz5t9IVLLKchZqMd2IJdcbfs04HdLKxRDu+XvJ95
/2GjjGz0X+kD1uv2LYM5jG6RQPXDPoYO2g5YKwmdh1HsIqLDX7gAf9xkGq7vz08s
Ebp2DjvKWlaBjmEvjyKDuoWivuaxjdE8w3NPTR1aj1qaN2ScjRtmpUgrsHi9C3zN
h8IhU4C3BXc21MIbUDSC67ggqG7z8ZsMqIotpjrNFpXyNPDxiXg5I6KpNek+M88w
LHmBxGmvGAsALBJ56sntg5YFo/Avz4u5Cxm4VE2UriCH3RMXAnlPQwYhZUyQ5cHF
DcUvUPOA6RPddSP4+iXRMm8pdWfWPZTHqRR5pBtwcUprlGhwBQ1cMr1ipeK8AE76
A1hkYujKZgWCVMWkGEv2dEvrW2WvWbEvvU6bVBRmHaUsmGDBZCaJ1QM+b3YJXEAv
//gVVcxhXM0zEtR7CQJ1EWjCASsDOSML9tUTwXonvBWEgoSdtlkUAo4aUjKSthg3
4lQJ4ePGHFr6+OGEShTmhN9W+H4MOLKZ9TjeDMHboN1jXekvN+R3a+hg8O/tnQ1M
kTG2EgY4eKVf6YSbxqBvKDbRQdeoGj0xoJ0fGS9J5BY5H6HgBDVETf/3qqJgMrxM
mwjLxdRbqU8j+L6jYTZ7
=KYAY
-----END PGP SIGNATURE-----

--Sig_/Q7PpeNDyYP8_i5ip7mWfuAb--
