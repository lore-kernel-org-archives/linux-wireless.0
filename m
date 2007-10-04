Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758158AbXJDSOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 14:14:40 -0400
Subject: Re: [PATCH] zd1211rw-mac80211: More complete configure_filter
	implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Daniel Drake <dsd@gentoo.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, kune@deine-taler.de
In-Reply-To: <200710041644.45038.mb@bu3sch.de> (sfid-20071004_154801_048419_79B7A18E)
References: <20071004113509.E5FF29D502B@zog.reactivated.net>
	 <200710041644.45038.mb@bu3sch.de> (sfid-20071004_154801_048419_79B7A18E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RrBqNA5Oz71tjbFcCTML"
Date: Thu, 04 Oct 2007 20:14:55 +0200
Message-Id: <1191521695.7367.6.camel@johannes.berg> (sfid-20071004_191442_964588_5B335000)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RrBqNA5Oz71tjbFcCTML
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-04 at 16:44 +0200, Michael Buesch wrote:

> > +static inline u8 *zd_mac_get_perm_addr(struct zd_mac *mac)

> We talked about these obfuscator- (a.k.a. helper-) functions on IRC... ;)

Actually, I think this one warrants an implementation along with
SET_IEEE80211_PERM_ADDR(), but whatever.

johannes

--=-RrBqNA5Oz71tjbFcCTML
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwUtnqVg1VMiehFYAQLiDw/8CMODrG9ytUUDI4wc3E1tiDBCC4bg9qig
SzC7gW6VbpfWedIwGkr7E0FZ35+YK/dPp0KK+LhFj0C2V2T4AqLtSSuANpU+63DR
2MI5wd/XHCa4DRojUAJBA8dRVtgS1PmQtzfEaOZQbqCON7uvcU9msaPHqcyOk/hD
R1tFyWxTLgJfljrXe07VmBX0SODTZuakhk29hTdIbPmYyQgMUrNFt9eSUMNL13p8
6VsYAbzru97pgsMlnugHbtMHHsEVAo5UKaruWU8VSPprOGZIwq7OdMRrOd/lPjKw
lfXn7uaqcE/ToLBYJKLCoJVkdf74gWLaSh/J+5EAuZ34oYDbXRK1pKYFhFd8sJ94
jvP0BNSNpVRPF6L62bamJxswAY2qztq83b7minsX5zkeYWX3/Bm0JeXDQO3mQ7/k
4lgm/VPw3i9Uu2+5uusy/vlqILR5WLL4G9zN2wvZ/91njnhdv2vQ9W7DC9O9u/nj
tGbXpEgIeBkN/+QQ2KHILe0gUaJ8WJGAP635hrrr/9yPNH7z5pnrvAFfPRPCjDBI
PtSm7U6u0qM4QXHJsH3qE6ZFcmP3Qka5Nz6PWpps10Xkv/puFgccAaM7w4Pevy4y
t4fuGouUNdWFjMC98MMgv9SqiLwA6YXniRXr7p3TdLMYiS4h68+s7X4OFgNmO85v
ZVfkgmVxjmw=
=e8fi
-----END PGP SIGNATURE-----

--=-RrBqNA5Oz71tjbFcCTML--

