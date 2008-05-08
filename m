Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYEHP2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 11:28:40 -0400
Subject: Re: 015-mac80211-tx-info-skb-cb.patch
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200805081734.23354.IvDoorn@gmail.com> (sfid-20080508_172446_517725_0910B37D)
References: <200805081503.41025.IvDoorn@gmail.com>
	 <200805081710.03869.IvDoorn@gmail.com>
	 <1210259130.3547.59.camel@johannes.berg>
	 <200805081734.23354.IvDoorn@gmail.com>
	 (sfid-20080508_172446_517725_0910B37D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MLW79PZ48PsCfwG6aM/k"
Date: Thu, 08 May 2008 17:28:29 +0200
Message-Id: <1210260509.3547.62.camel@johannes.berg> (sfid-20080508_172739_477509_2264D61F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MLW79PZ48PsCfwG6aM/k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-08 at 17:34 +0200, Ivo van Doorn wrote:
> On Thursday 08 May 2008, Johannes Berg wrote:
> >=20
> > > > Right :) I'm pretty much done with the skb->cb conversion too excep=
t for
> > > > ath5k (nick) and rt2x00 (you)
> > >=20
> > > I'm going to rebase rt2x00.git this weekend to update from wireless-t=
esting,
> > > since the skb->cb patches now depends on HW crypto which is not ready
> > > for upstream yet, I am going to reverse the patch order so the skb->c=
b patches
> > > and some other updates can go upstream more easily.
> >=20
> > Cool, thanks. If you have a single patch that can pretty much go into
> > wireless-testing you can send it to me and I'll roll it into my patch.
>=20
> Well at the moment I have it split into 2 patches, one that is only
> preperation work by splitting a particular function to guarentee the skb-=
>cb
> rules are being followed. And the second patch is the actual conversion.
> Those 2 can easily be merged into a single patch which you can roll into =
your
> patch.

Whatever you like better. Maybe it's easier to follow the code/patch
flow if your preparation patch goes in first on its own?

johannes

--=-MLW79PZ48PsCfwG6aM/k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCMcHKVg1VMiehFYAQJu5RAAuhNo2K7Nk2J0yI1atjjXNbF10hDGkhdN
31dv9zsxPDTzr5fYRSP5g2LDrUWPx1H6KsyZ7OqIDncodyUMbueDixp9d4dcPwHC
mfjnjb1fU8MIDZWidUEdk7h2vikv6kOdq0PQb6yXMy5mdCK1hWECmAdtvz+bzpBv
OWnfZuWFHnHB39bJAWjuIzbr18oszb/b4GFRP9rDXA2y8Vpc+NOl3+BUZgOgEKa6
5uOkcmZGMn77AuDDOvJJnQCrnX9H8lgG5AMI99MN9o6GkVZb9hQ/cJMY0oKp0aqc
uoPrEfXUcUHQj1gtyZ3NoMKHPXYRrhMOYno66GaEETnpEx7fz6brtjAPxmLM9hyn
Re8ohou/33YxIkP35qWbl9WyQybcsy0++eN3IkhbckMFkL7f0SeK7bpPiNuFi0Nx
93g15NrNQJ2mn98PXLVSb5YH3YaZFOoUYt56kQySkvCClj80FMM57/ZZJm1NROXs
vhORBfy6fXGf6Wny2pL6t5swlDFdA/1/7dNscdfogBUTO2Y8tadgSVPvMPSdSZLO
7vHPwwTJZCy/isN809dFXrzK+Me3fUqp0KXtTxEuGkDW21PkyVIqrIEHyq3qmAE8
yXkH1ttYEOf/2zk7NOth5lKiLXo+IF4Z3RKOhvU89RzjWhBV8gxiuVU5fMjO17Ac
AcdzONWzMUg=
=yM+q
-----END PGP SIGNATURE-----

--=-MLW79PZ48PsCfwG6aM/k--

