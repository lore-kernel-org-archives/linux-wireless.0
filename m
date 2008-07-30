Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60922 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbYG3HRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 03:17:19 -0400
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217347091.6379.57.camel@localhost> (sfid-20080729_175816_515768_CDBB713C)
References: <1217323927.10489.9.camel@johannes.berg>
	 <1217330604.6379.12.camel@localhost>
	 (sfid-20080729_132329_995714_6D2C9701)  <1217330667.10489.19.camel@johannes.berg>
	 <1217331773.6379.25.camel@localhost>
	 (sfid-20080729_134300_214751_172329C5)  <1217332288.10489.33.camel@johannes.berg>
	 <1217333020.6379.31.camel@localhost>
	 (sfid-20080729_140346_036234_85BD2AA9)  <1217333247.10489.35.camel@johannes.berg>
	 <1217347091.6379.57.camel@localhost> (sfid-20080729_175816_515768_CDBB713C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ecRnQejy5VCjAp7vITwY"
Date: Wed, 30 Jul 2008 09:17:15 +0200
Message-Id: <1217402235.10489.83.camel@johannes.berg> (sfid-20080730_091723_345501_321BAADD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ecRnQejy5VCjAp7vITwY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 17:58 +0200, Luis Carlos Cobo wrote:
> On Tue, 2008-07-29 at 14:07 +0200, Johannes Berg wrote:
> > Ok. How is that supposed to work with crypto? Do each two peers
> > negotiate a key and forwarding just doesn't change anything so crypto i=
s
> > effectively end-to-end?
>=20
> Actually not, crypto is per link (per hop). We don't have a schedule to
> support that but anyway, where do you suggest to save the mesh header in
> this case?

Can we just retransmit the frame directly to the master interface, with
all that still intact?

johannes

--=-ecRnQejy5VCjAp7vITwY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIkBV4AAoJEKVg1VMiehFYHFgP/R6jrXIU2YsfNUY0JjRvEf5B
4E+IBGsQuIGe5lclMC5N6wQwZUxjVjpxk0GhaysiFcqja1vvzj+0pzMlbm/E1Sv0
zVn7ysdDl3fzlc+nHnC8diSAnLZ34ZqOx+f1W/DMkO2IkO5Qrwdw9HpB9+H+hUzw
Ef2lbwX2P6QeqDGei+DpgqZiC5zDLhIZsMMMJ7pHLAlxXqcECdmtyhIvLkk94YrX
VT/2N3p+0Zg3oAjx/CEEphIat/VhXfw1/gYAxW910QEnK8HAZr1MSWKI+BygVQYB
AkTiblBuQ6OAT9/N+kZ9o+dvItm5J/I9N7WvUQB12IAT95He9LvnYkNv4fzhr+Wn
dSBw07m/E1jhZMYddCoK9WmGNpqvFSX4maBbxgNfQ1mtLsrItwSaLim3OacEcKEg
KbdBdlxqjPapSRorAO/b1YZHfGVRVMZEUwmq0y6NiF5HfFSw/D9Q+qapik5Z2hWT
p4gBaFTOiYBxAH6THA18neUW/IfrlXi0urcvI/FyDVnuodaWMDYGV4BV1qyXM0b5
Zfli8fStS00CAIYm5964K5hDtv3g60HHonsXlE93SzsVHiBln6rmDHCXnCCeoIVC
7REAaPaLXDWujhjzFPIAJIDGMVigJXk65Ew59oKkRhbqmfzzorJK5hYipl1vcRO1
PrYXCxt9OJ4bkYx0FBh0
=pO42
-----END PGP SIGNATURE-----

--=-ecRnQejy5VCjAp7vITwY--

