Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42725 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758882AbZFKK3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 06:29:36 -0400
Subject: Re: Sending netlink messages in mac80211 tx handler
From: Johannes Berg <johannes@sipsolutions.net>
To: Reiner Herrmann <r_herrma@informatik.uni-kl.de>
Cc: Zhu Yi <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>,
	"m_wilhel@informatik.uni-kl.de" <m_wilhel@informatik.uni-kl.de>
In-Reply-To: <4A30388F.1020701@informatik.uni-kl.de>
References: <4A2EEA07.1050306@informatik.uni-kl.de>
	 <1244596432.5034.27.camel@debian>  <4A30388F.1020701@informatik.uni-kl.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5T0q5gqTEhHiqnfd7Teu"
Date: Thu, 11 Jun 2009 12:30:15 +0200
Message-Id: <1244716215.4706.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5T0q5gqTEhHiqnfd7Teu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-11 at 00:49 +0200, Reiner Herrmann wrote:

> >>         nla_put_u32(skb, NL80211_ATTR_DISCOSEC_HELO, 42);
> >>         genlmsg_end(skb, hdr);
> >>         genlmsg_unicast(skb, get_daemon_pid());

> Thank you for your hint! I searched for hours and couldn't
> find the problem. It's working great now.

Can I ask what you're trying to achieve? Having local modifications in
nl80211 is a very bad thing.

johannes

--=-5T0q5gqTEhHiqnfd7Teu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKMNyzAAoJEODzc/N7+QmaFgEP/jYCuDzdwpQhyDX/XVMqF9Mm
5FZFWaiUf0GkK9msjSZ88HdlKgtlY38rsdQgvwDeKO6wQfWW9F6Xc/sFSXKKf3Pv
A+FWtWi26KTGCpRXwutvVitAf9Y8Gluc7sTDP21q3SP489kyN0g8jnLsMzKGUU8u
rjGcrRQgmISWmjG1ahvSwl/8Fynq958oyH6BQhMehD9CK8BdDKJ8pdIImg5x05pR
de+6PelmCXSeODKmojBmpfuQCwRIJlff+fVBDrVYdQvrKWm15J7OhDUh5xFqDyqz
fncMLiVh8xDDpPsIVPhPa5T82BrIltSdbbCVUT5XHhBwpyKeenCQOpZ9HCkfyXqR
3lewFCRetQwDDlxbvbDg1x3cA/36+CBfvFyayXL3ioL/s87gQcPyLd+6e8oNzaRI
yv3szVSVljV2TYfuNXKqrCSqh06JXP5lgvssW9AQwx5fh432/zctFW58dR2KBsWQ
GyT4KOh9rq0q1eUfif3nCr04pJxW2yd4dgMKf1sngED2lINlOIySSqA+/xxFdRwj
wrlB7CRfJueR6K5+MqqOAWxDFZhcgFNGKT+G5Ixcxc7ubr3UTNzplxe8ENv0Gk+O
Itbzsz8NPB1C3EttMQ3K9kUq/lXBp2wT2W0bTHdF4t9mjU2X2zIT0g86Zv7fFY19
r8sHxYzBmcOw2HBCGgGU
=3rKa
-----END PGP SIGNATURE-----

--=-5T0q5gqTEhHiqnfd7Teu--

