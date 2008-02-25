Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbYBYT5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:57:50 -0500
Subject: Re: [PATCH 11/13 v2] o11s: support for on-demand Hybrid Wireless
	Mesh Protocol
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203969107.6929.37.camel@localhost> (sfid-20080225_195025_352488_1B900D90)
References: <47be77ee.02098c0a.5eba.ffff81ef@mx.google.com>
	 (sfid-20080222_072128_730595_F951750B)  <1203697819.7082.75.camel@johannes.berg>
	 <1203967829.6929.16.camel@localhost>
	 (sfid-20080225_192854_280269_CEC357A7)  <1203967819.13162.136.camel@johannes.berg>
	 <1203968210.6929.22.camel@localhost>
	 (sfid-20080225_193515_727081_D7673A7D)  <1203968312.13162.142.camel@johannes.berg>
	 <1203969107.6929.37.camel@localhost> (sfid-20080225_195025_352488_1B900D90)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U3fVLMfmmU1nXpPbCOlE"
Date: Mon, 25 Feb 2008 20:57:43 +0100
Message-Id: <1203969463.13162.149.camel@johannes.berg> (sfid-20080225_195753_744841_B3536271)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-U3fVLMfmmU1nXpPbCOlE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-02-25 at 11:51 -0800, Luis Carlos Cobo wrote:
> On Mon, 2008-02-25 at 20:38 +0100, Johannes Berg wrote:
> > Huh. The draft says something like
> >=20
> > "includes frame headers, training sequences, access protocol frames,
> > etc."
> >=20
> > That doesn't seem to depend on the hardware but rather on the PHY type
> > used, i.e. whether you have short/long preamble or 5GHz etc. Am I
> > misunderstanding it?
>=20
> You are right, I assumed some of those values may vary among different
> hardware but have not going very deep about how to compute them.

I guess we should just calculate them in mac80211 then though.

johannes

--=-U3fVLMfmmU1nXpPbCOlE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8MdtqVg1VMiehFYAQL9Yg/+OhDiaxwj6Z5xbKVvj5wIFkwDWq8GhLVR
SOxhcobdu9FdaxIUkMPRUbW1kPGItFbjro5+OndpB0mfQgo43GLg6n8LYHWeUVkf
taTiC5DZlj+Zge1pVwcpWB8SbofBGcZKIwzL+NAyvzHAlnqbBsipYzCBsncs9hoy
8K8h5EVslztRGkIFyODBmj2dHzCblsVLaHCN6/IhIrjsLatVsdRUEF2CnvJ2qOvT
Et8bMsqtndGmGOc+cp5RCePT7L5wgct7fVNaSzwi4Ax6oY4ktAEadLN27bwcItEl
e+BUPeSXoN+tdy34tunVd28Mj7WqiU+qLQes7Yhem4+63nCchOjhRaBeGg0Sen1B
37p0rEvN1RU1JCsUHiOqWRDYVvWBh9tBGco+GDL4w98i5TOFiWEKpNYMaDwRHcgz
Na0B1/1feL2N6esWGh6XXFPSuX9v8SpI5UKU8J8zaP/jE0MDm1GvNxn5OpKsIQxW
ybnDeR6ctQLxeJ/uvrTcGZbcy1CGNzvNZ4k8zMMZtoRugnfIMJkkdEEUvP6ZibGj
vxZzeLbMIAj3f/o+gkyG7yqn+L03cEVrpcKSLU8t//fBd8H4+BxgBhOTjPlOcWmG
3J2B/0GqoTg7mB632kw89ogiRaypvGXmYNyQ51jgWb+OGOzgLZBdygzhzfzZsZW2
rOb4mJnnhWM=
=cGuf
-----END PGP SIGNATURE-----

--=-U3fVLMfmmU1nXpPbCOlE--

