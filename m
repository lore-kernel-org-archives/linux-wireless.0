Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbYB2Q0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 11:26:06 -0500
Subject: Re: hostapd with mac80211 progress
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1204266154.3090.182.camel@debian.sh.intel.com>
References: <1204190255.3090.165.camel@debian.sh.intel.com>
	 <1204210453.6309.49.camel@johannes.berg>
	 <1204266154.3090.182.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5Kc/D2oh+LqmbCn95kRO"
Date: Fri, 29 Feb 2008 17:25:56 +0100
Message-Id: <1204302356.3938.36.camel@johannes.berg> (sfid-20080229_162611_741965_A97D96DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5Kc/D2oh+LqmbCn95kRO
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

Ok, now that John merged more stuff you should only need the hostapd
patch and the allow-ap-vlan-modes patch from my kernel series :)

johannes

--=-5Kc/D2oh+LqmbCn95kRO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8gyE6Vg1VMiehFYAQLSeBAAojU94QDLhBqees5G1CXvq6vBpLZRWUkJ
RH4NyMMmx/MZaJO/vH/36YS2U9/66+iduh+CIFb9gG9kKKmbaJv1ZUMcSbqqCknn
1NUMmG+gurFSxZIczWjGzxRb2+84DSm+ftFYvQy0llEyjPWJKpqlHdf//quvwQgn
uYwxXFAEQJI65h2wfVuOICjrnDIXiUSPOWO1uPPfzODhoL/moBmVFg0DnHzNp9Au
jZdHelE4DhVmf86L+mSXO4EER6irFJJiiLlz2idqP3MMMDLKZuzfc5IBmg6furQK
LZ4u3NbTGJUt375JO2Y2GFIOrHZXk/m8LDFLnxliHamBv4PfAgDYfXBLzVS7UIfs
LQ7t6huVMph305Pv+m7ynzCrh8qRGbGv8MLiGr6CHB0dvnRpP/ibmLCK6a1RjYio
z95F8GvNn9HQXTuhCelxtjO4f2gHRAd3c0b+cKrmG0ZxvbJ2FRfTCu7LK+Sw9H3m
DfSybPFH4lVqY61JTOuJ+u2WiNZdbPnz1C6wESCcRbXxvSfqn1CsD6zhH20qZAJU
5uHFLvj/F7KlNmBavvFYq7qXFUAnOOowAIc/qVXwjyz5tKEMatJWA/ExlOO8Jwcq
+GhZvpKzFKdOd/5A1+VZuXRPc2Ws5vUvRKhCnYOEnF5J2AsDX0zOJBUTuRyAK1TH
XpvAvhiKFMc=
=XwFX
-----END PGP SIGNATURE-----

--=-5Kc/D2oh+LqmbCn95kRO--

