Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573AbXINMG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 08:06:56 -0400
Subject: Re: letting drivers choose their preferred rate scale
From: Johannes Berg <johannes@sipsolutions.net>
To: Ian Schram <ischram@telenet.be>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46E9AECE.5050305@telenet.be>
References: <46CF95F9.6090802@telenet.be>
	 <1188028962.9529.13.camel@johannes.berg> <46D01D57.6060806@telenet.be>
	 <1188211749.6756.11.camel@johannes.berg>
	 <20070831180933.GB3352@tuxdriver.com> <46DB537E.8030801@telenet.be>
	 <1188808692.14564.24.camel@johannes.berg> <46DC1500.7090808@telenet.be>
	 <20070913183918.GA10239@tuxdriver.com>  <46E9AECE.5050305@telenet.be>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VyYbd63sgvQ9dJS3aryn"
Date: Fri, 14 Sep 2007 14:08:17 +0200
Message-Id: <1189771697.3974.30.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VyYbd63sgvQ9dJS3aryn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-13 at 23:42 +0200, Ian Schram wrote:

> The whole point of this exercise is to make simple the default.

What I actually wanted, though, was to have the default be a string that
is settable at runtime to any of the loaded rate control algorithms.

johannes

--=-VyYbd63sgvQ9dJS3aryn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG6nmx/ETPhpq3jKURAuDcAJ9io1xlY2GUXmaR1K5qqLZT8QE5ngCfXDQ3
sqR/2T6TfNhIa0FdgUWk8VU=
=HXjy
-----END PGP SIGNATURE-----

--=-VyYbd63sgvQ9dJS3aryn--

