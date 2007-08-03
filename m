Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763123AbXHCWe3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 18:34:29 -0400
Received: from [84.135.224.6] (helo=[10.0.0.4])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IH5j1-00072S-Aa
	for linux-wireless@vger.kernel.org; Fri, 03 Aug 2007 23:34:28 +0100
Subject: Re: further plan wrt. monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1186179954.20275.3.camel@johannes.berg>
References: <1186178959.13315.30.camel@johannes.berg>
	 <1186179954.20275.3.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QpSQEfcygp4dAIp5P+H7"
Date: Sat, 04 Aug 2007 00:35:29 +0200
Message-Id: <1186180529.20275.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QpSQEfcygp4dAIp5P+H7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-08-04 at 00:25 +0200, Johannes Berg wrote:

> On the other hand, with these changed semantics open/close could make
> more sense again

In fact, it seems it will be required because drivers won't be told
about new monitor interfaces, and keeping track of add_interface *and*
the new flags seems a bit tough especially since some flags could still
be set when a monitor interface goes down. Or something.

johannes

--=-QpSQEfcygp4dAIp5P+H7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGs62x/ETPhpq3jKURAkPAAKCBeusniw5rc+YKLnzRNCiIcx5WMwCeN+SX
b3ORa921Lj3JnRmw3+67NGs=
=TFsV
-----END PGP SIGNATURE-----

--=-QpSQEfcygp4dAIp5P+H7--

