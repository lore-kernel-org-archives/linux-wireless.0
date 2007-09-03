Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbXICIg5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 04:36:57 -0400
Subject: Re: letting drivers choose their preferred rate scale
From: Johannes Berg <johannes@sipsolutions.net>
To: ian <ischram@telenet.be>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46DB537E.8030801@telenet.be>
References: <46CF95F9.6090802@telenet.be>
	 <1188028962.9529.13.camel@johannes.berg> <46D01D57.6060806@telenet.be>
	 <1188211749.6756.11.camel@johannes.berg>
	 <20070831180933.GB3352@tuxdriver.com>  <46DB537E.8030801@telenet.be>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FlpbFB0RsNxQ9o1yULUT"
Date: Mon, 03 Sep 2007 10:38:12 +0200
Message-Id: <1188808692.14564.24.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FlpbFB0RsNxQ9o1yULUT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-03 at 02:21 +0200, ian wrote:

> we could additionally remove the module_alias from rc80211_simple

indeed, please roll into this patch

johannes

--=-FlpbFB0RsNxQ9o1yULUT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG28f0/ETPhpq3jKURAu1HAKCemxJfDbZ12fKMrvoPdlkHkox4JQCgrOrH
h6Lon/fdye1o684/5xsU4Xg=
=GBQA
-----END PGP SIGNATURE-----

--=-FlpbFB0RsNxQ9o1yULUT--

