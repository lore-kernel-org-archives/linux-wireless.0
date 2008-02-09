Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59634 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbYBIJI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Feb 2008 04:08:57 -0500
Subject: Re: [PATCH] zd1211rw: debugfs access to internal device registers
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47ad13ca.1f09360a.3958.ffffbca3@mx.google.com> (sfid-20080209_024552_713361_1C04EEBD)
References: <47ad13ca.1f09360a.3958.ffffbca3@mx.google.com>
	 (sfid-20080209_024552_713361_1C04EEBD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NJAXBv4Z/1traVD2Bpei"
Date: Sat, 09 Feb 2008 10:08:48 +0100
Message-Id: <1202548128.24811.13.camel@johannes.berg> (sfid-20080209_090902_831452_36EE067E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NJAXBv4Z/1traVD2Bpei
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +static struct dentry *zd_dir;

I think you should use the cfg80211 provided per-wiphy debugfs dir.

johannes

--=-NJAXBv4Z/1traVD2Bpei
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR61tn6Vg1VMiehFYAQKe3RAAiSVOPpwIJrbZASQ1vakmeqoM6H8+WyeK
J1CFCD3s3nMyVv7inJNpgZXHVenXROr396ENEYzKPm3qcCq4aV1Hr7EDn5Gf/rAe
OIYB0JuQyGgauKx7norXKcV6HMeNsa7tj1CewmB/+GL1s7z8DWXNdYEUFcBp8ze9
cy1/ZptamII82cI3vza1eeGojxTmkJpB1qa+n9KVITsyPyJNPYt7kuVynaQj3Ud4
f7JYn69+iMcs3zeu0Mv0xusYdG8wNajQweo5AsnXDKVtcsqon+9U6OEL2fuTM61u
EU13W9ZWWRK+hEcGSzJosuf4PYZnvey+Z99uBdw/T6o93I/spWOU1vUf47+wIJUG
1Ut7u8Y52XrFUNZzfodInKOxdA1Ij5g5bMe9dzfoVfuTWW4yfrPTI9h6lRESUC4w
2kfQJCkMgb3P7rQu2pDBJwBvWLeHvAPvpSJMQdkYF0Pdm+1NiMZOTUJ13vo98ryp
8d45hTX0pKtPFhf9AfNTX4Ic7QZA1JpEWTi6UZlnSXZgNkaiKuZDqFmV1D3I9atK
Qb6+bQIRG0xd5SPW4MEuWN6/Oei1psMtkUBA8vuQ5ihPYUtihL0ejefsTiRWLQFb
4rYexw37HppG/lyAem15YLQmEKdcgtSCUe5c5ozNNX/UT+6uK+BApZSdo8ceDkDC
DA2LdgHjnnw=
=Rbdf
-----END PGP SIGNATURE-----

--=-NJAXBv4Z/1traVD2Bpei--

