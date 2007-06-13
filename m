Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60715 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168AbXFMQJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 12:09:10 -0400
Subject: RE: [RFC] {cfg,nl}80211 API
From: Johannes Berg <johannes@sipsolutions.net>
To: Mark Powell <Mark.Powell@csr.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	David Lamparter <dl@diac24.net>,
	David Lamparter <lists@diac24.net>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <F3555D2D288C3C4CBA0001C074188F119F8913@cameurexb01.EUROPE.ROOT.PRI>
References: <20070611230434.GA13221@charon.n2.diac24.net>
	 <20070612131458.GA6411@charon.n2.diac24.net>
	 <F3555D2D288C3C4CBA0001C074188F119F88C3@cameurexb01.EUROPE.ROOT.PRI>
	 <200706120945.41154.flamingice@sourmilk.net>
	 <F3555D2D288C3C4CBA0001C074188F119F8913@cameurexb01.EUROPE.ROOT.PRI>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nOPPHGKSLpc9Gr/l6B9h"
Date: Wed, 13 Jun 2007 18:08:57 +0200
Message-Id: <1181750937.29767.89.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nOPPHGKSLpc9Gr/l6B9h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-06-12 at 18:01 +0100, Mark Powell wrote:

> This is to do with the operation of the "Controlled Port" as specified
> by 802.1x, which is handled by the driver. When the key exchanges are
> complete and the link is secure, then data is allowed to flow. With
> wext, the driver has to guess when this state is reached, based on
> knowledge of how wpa_supplicant uses wext.

Is that really something the driver needs to handle? I see controlled
port operation in mac80211 but I didn't dig yet why it is necessary. As
Michael points out, shouldn't it be possible to handle it entirely from
userland? What userland are you using that needs the driver doing it?

Of course, there's the question of whether to accept packets anyway or
not, I think that's what the 8021x setting in mac80211 does. Not sure.

johannes

--=-nOPPHGKSLpc9Gr/l6B9h
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGcBaZ/ETPhpq3jKURAhC/AKCpEy04DxppOsRGW+k9hKernfyFmACfbk/u
VkG2xn2Rk8o8uqCIBBp611I=
=aT7Q
-----END PGP SIGNATURE-----

--=-nOPPHGKSLpc9Gr/l6B9h--

