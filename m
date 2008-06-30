Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44821 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940AbYF3LHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 07:07:40 -0400
Subject: Re: [RFC PATCH 19/19] orinoco: Add MIC on TX and check on RX
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: kilroyd@googlemail.com, linux-wireless@vger.kernel.org,
	proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
In-Reply-To: <1214776609.6037.11.camel@brick> (sfid-20080629_235718_050248_F270D991)
References: <1214678305-7057-1-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-2-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-3-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-4-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-5-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-6-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-7-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-8-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-9-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-10-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-11-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-12-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-13-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-14-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-15-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-16-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-17-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-18-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-19-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-20-git-send-email-kilroyd@gmail.com>
	 <1214776609.6037.11.camel@brick> (sfid-20080629_235718_050248_F270D991)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SZTHW0vhwr3wgke5txlB"
Date: Mon, 30 Jun 2008 13:06:48 +0200
Message-Id: <1214824008.5507.34.camel@johannes.berg> (sfid-20080630_130742_992107_D98D523C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SZTHW0vhwr3wgke5txlB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-06-29 at 14:56 -0700, Harvey Harrison wrote:
> On Sat, 2008-06-28 at 19:38 +0100, kilroyd@googlemail.com wrote:
> > Use the MIC algorithm from the crypto subsystem.
> >=20
> > Signed-off-by: David Kilroy <kilroyd@gmail.com>
>=20
> Any reason not to use the net/mac80211/michael.c implementation?

Yes, depending on mac80211 for a full-mac driver wouldn't be too
smart :)

johannes

--=-SZTHW0vhwr3wgke5txlB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIaL5FAAoJEKVg1VMiehFYmAsP/0eV6V+k3pqgr+y70fnnGGQ8
gT466/1fBoYtNQAnov0GVZ1s6GWDg9zGk+29kiRO5Yn09VsC9vgH92b828uMW6l4
KdYkuJh4vo/GFygGyMKdoS82N6AOj/6nzoThG356iTJjDOymLzB4b3PpJe8wslpQ
dmVEmABl7f0VJK5hZWalXQQQDkwAnnYGZH/lotpuPGgQzKIwfHdy5OWdfQ7dPj6h
tJBKomEU8K6V6RV4cLlVouGk2mYkycbzLtCVeluBMiFWHnjRskGYNKTrS3g/44XH
ehP6MRS9EV2FCQ2+6M4gCkg0a4rLBj/3bEiQijNdgvon9ckD/BQ7JhZZup777TKT
qCMzrxYIIkOg5O2sHlvxeANPmAE2odysFf0Vj2sgOiQxCAtsY2ggOOCPJvTxofdg
TeCf7oeNNxKYHy1xbauucNeAS3x40vy6PgLBkgsQt/b916ju3vvfYasi6u/ou3XK
BuMQNJYyiSJabA03z0kv9H2HWWLvIu7sVTtR5Gm2IOXPEvIE6JPS7n3H8pcFOGB0
C12gby+KutNe1ClfVP9M78KgB7UD01n4kh/rx7xMHILVfGGJjThkUqwUoPdrxeXC
nGmVLFNSj4QzWvCPbpYq+XfQh7BUCfmFYcr3J7ly1oYbrVEaKWATXLAg8mzsmllV
Jq8aOX+XlzP6fGzJJmNU
=JpSQ
-----END PGP SIGNATURE-----

--=-SZTHW0vhwr3wgke5txlB--

