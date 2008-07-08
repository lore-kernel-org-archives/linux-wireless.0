Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYGHLwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 07:52:32 -0400
Subject: Re: [RFT 0/4] mac80211 improvements
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200807081353.53559.IvDoorn@gmail.com> (sfid-20080708_134540_779962_5FA6251E)
References: <20080705234735.210585000@sipsolutions.net>
	 <200807081353.53559.IvDoorn@gmail.com>
	 (sfid-20080708_134540_779962_5FA6251E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6TG6izxJbFCh4LmmW8ad"
Date: Tue, 08 Jul 2008 13:51:47 +0200
Message-Id: <1215517907.9610.31.camel@johannes.berg> (sfid-20080708_135235_186335_7C96F0D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6TG6izxJbFCh4LmmW8ad
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-08 at 13:53 +0200, Ivo van Doorn wrote:
> On Sunday 06 July 2008, Johannes Berg wrote:
> > Here are a number of improvements for mac80211's virtual interface
> > handling (master netdev, cleanups) and driver API (beaconing).
> >=20
> > I have tested these patches on b43 in AP, STA and IBSS modes
> > (communicating with my N810 or an AP) and have not seen any issues.
> >=20
> > I would appreciate testing on other hardware (I can probably cover
> > iwl4965, rt61pci and zd1211 next week), but I don't expect much
> > trouble.
>=20
> I have added these patches to rt2x00.git for testing purposes.

Cool, thanks, let me know of any problems.

> And to be more precise, the following patches have been added:
>=20
> 004-mac80211-master-not-ap.patch
> 005-mac80211-iface-cleanups.patch
> 006-mac80211-push-alive-check-down.patch
> 007-mac80211-beacon-revamp.patch

Those I intend to push soonish.

> 008-deprecate-sys-wireless.patch

That one too, but hal (depends on it, patch is in git) needs a new
release first I guess.

> 009-local-bh-enable-consolidate.patch

Ingo Molnar is handling that one.

> 010-linux-radiotap-rxflags.patch

Pending radiotap list discussion about those new things, but I'm fairly
confident I'll post this one too this or next week.

> 011-allow-ap-vlan-modes.patch

Well that we all know about :)

johannes

--=-6TG6izxJbFCh4LmmW8ad
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIc1TQAAoJEKVg1VMiehFYJycP/1jmOkufUHtU1M4i74gTyQ+z
JcEULPTJsFyn+xoLKehnxZL0sakh7wJec0zvmmNJKofgul9mpNdIujpS5WpipCBp
1jb2JFxJ5EyJxGTr0+nFBO7YHklwDiEl7rhXyT5HXb1BriAqS/0WJJxd4P7Mowny
aP3JnMwD6z3uVVKNVbXnlw9Act/yGjnK7zZTfDkw2/sX5C/XZ2+wq20Up+4uuLGx
P87erJrmsTwRIW3tnJnJV6tBLT5rpXJlO3R+iYcxj68eBEhlYW1lKBFz+G9q80U2
PY4FRez0Ja1Jqg+9pJxB3QuMTMPDZZJP+7vfismvOHDqGLzANctlEm/6mrAy7HDD
GfRUX5mPVs2+QD7Shu+5KupoaWueKwvjZRbbXOj9+KM6Sz6mXNbutauxp98pQ34l
a1c7cGD6DXRqKbVLk6H85Mf5Waml6llqah4SzYGKyFU/QMgxqNpnbtKQhWmS7rd0
RqF0covPWYt5uH7vnarb/xDHr17d8WlJ8HLtH3Cbb7XSdLuQs3f9a3oKvn3Wzidc
NhBZaoGW2njQoe2OpcCquQgHe6oFfjE5EZbGjyxUsA8R7sZXC+473+MZu8v75+pL
HahLjb91pIAtDj92xofbO83l4KMBiJ5Fpe+M+PRwmuz2WNwhGa7gd/6WV1JOuLlJ
MjdrJkQg1/yZz24TkaTy
=WP/i
-----END PGP SIGNATURE-----

--=-6TG6izxJbFCh4LmmW8ad--

