Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000AbYB2PyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 10:54:12 -0500
Subject: Re: hostapd with mac80211 progress
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1204266154.3090.182.camel@debian.sh.intel.com>
References: <1204190255.3090.165.camel@debian.sh.intel.com>
	 <1204210453.6309.49.camel@johannes.berg>
	 <1204266154.3090.182.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OSFX+B7G5WDpAsm/U/UH"
Date: Fri, 29 Feb 2008 16:47:39 +0100
Message-Id: <1204300060.3938.28.camel@johannes.berg> (sfid-20080229_155416_563262_C74E68D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OSFX+B7G5WDpAsm/U/UH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-02-29 at 14:22 +0800, Zhu Yi wrote:
> On Thu, 2008-02-28 at 15:54 +0100, Johannes Berg wrote:
> >=20
> > Yes, you need at least the one hostapd patch I still have and also the
> > trivial AP mode enable patch. I'll rebase my patches on the current
> > wireless-testing tree in a minute so check for patch uploads later
> > than this email.
>=20
> OK, I've applied all these patches. The kernel doesn't compile unless I
> enabled CONFIG_NETDEVICES_MULTIQUEUE && CONFIG_MAC80211_MESH and with
> below patch.

yeah mesh is a bug, and multiqueue means you applied the BROKEN qos
patch :) Go for all patches up to that, not including.

johannes

--=-OSFX+B7G5WDpAsm/U/UH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8gpGqVg1VMiehFYAQJfKg/8D5GjoS8K/GmWxBmMMVuzzzX84/yffLb0
5EeUfN9EEROKDnuP7THPBoltGZbizQ3Ducc8tJa1OEB4U+T1fuWJhutn7/BTXR7e
S5baLRNVEkWQZ0XDNI0YHNe82xEQHjkiw/7XH7N/rsNAMDzxjN0gXs7pJ8by+Lho
lK7ziMXbr6/i/1z3YKqaB3Ph6455qYD2e1sL/633j1yrAPnZ2BxPv4cVnGQ22zWS
Pxw0MPsntQmgwffbcvvq1Rz3uuNYFY+0EXVO8hVWQoYFsFX7q1AHiJ5D1lOS6L1U
DSyieSC03p4FsZ4HE+unBikG9JoAvKIEzLTpKq39UQ3HR5Fa12SvjGIvgoBPlzF2
Eoo14YWm7H2W+pFNM/RWRL5URbUFEuDBwCoosK0VSOLh0K8vJA8bVrGIBZc1j8wn
6sIKdveqLTd4NA8ChGLcO0Sq7BgQqv9q/+nl9qt4kpt+T8EWeI7p2HyezBTN6u1F
8/A44ipZB5ZnC4LLTwlI8MFh4OyDhG6FOojtz2Aa9Z1A2WOgP3UzixnO5mPkNU/3
HKvya2zo8Thl5TPLr1Ip+32eklfowjXTKjjtsUAuxYtrs9vlUkzjsyfTG+9fr2BX
aZISEJyp7LbG3VSTbHZfvpuAhrEFEXW6DHNPqKxvCp1e4ZWl/gchrLbwe4QzPV5n
IlsbxV+w89I=
=/oCK
-----END PGP SIGNATURE-----

--=-OSFX+B7G5WDpAsm/U/UH--

