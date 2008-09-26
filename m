Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40921 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbYIZTaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 15:30:22 -0400
Subject: Re: wireless-testing modpost failure
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Davide Pesavento <davidepesa@gmail.com>,
	linux-wireless@vger.kernel.org, YanBo <dreamfly281@gmail.com>
In-Reply-To: <20080926190007.GD3483@tuxdriver.com>
References: <2da21fe50809261104m3b7d99e3g8b56416b8182ca45@mail.gmail.com>
	 <20080926190007.GD3483@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cuBd8jiwTPxNlK17Ec4J"
Date: Fri, 26 Sep 2008 21:30:16 +0200
Message-Id: <1222457416.3798.25.camel@johannes.berg> (sfid-20080926_213025_707792_18A6FFB3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cuBd8jiwTPxNlK17Ec4J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-26 at 15:00 -0400, John W. Linville wrote:

> >   Building modules, stage 2.
> >   MODPOST 216 modules
> > ERROR: "mpp_path_lookup" [net/mac80211/mac80211.ko] undefined!
> > ERROR: "mpp_path_add" [net/mac80211/mac80211.ko] undefined!

Davide, can you tell me what file/line it fails in?

> I'm not sure what the best long-term solution is.  Should we define
> empty versions of those functions when that config option is unset?
> Or just make the whole block subject to that config option?

The weird thing is that the block in tx.c is already ifdef'ed out and
the block in rx.c should be optimised out entirely.

johannes

--=-cuBd8jiwTPxNlK17Ec4J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3ThDAAoJEKVg1VMiehFY3zEP/1DA1hRbG4+AfWdlrdp0THrn
6hyzSE46CmPmE4K/41asXYAmGk/47DM4V0kdqR+8gS4Lu5noHqVu/rNRL/zjpcb0
1hmnnKWouK7Mek/jkDUwj7n216Et6C4qzj52sLU1pSTlbkuFVvP2PVChUBlA+pzq
Qv13mvTBBC4wPG9cuVc4pefARcyUjURXYMvlD3r3UKzS4xxqBpiekhACa6OD3AOM
m9Emm1ekQfhb9/6VGMkySvwHQlA94n20D6UtD6m/Esh/OE39o9gBWvQTZ/Qyjtdy
EwxasBYC0HWMnaQfH7KRvRRg8H7HdyGc9H2w/p7lj3lUSvXhMjUpzPTgbh0Cd5e2
ZXBlGHQX8FETBHEvJWxKRbq/1ftoL1KmRdYwVh1qZlsxOtmoJfPCeDP+NHgGd7yX
E/cqZKXaGJgw8XNzsDyrH2SL0SIT/lbuDamQoTHrCtJdPScY65ggZbK/hNp11fWg
OoG4SWdHtPpCvR9GrIJ0WGyeMIyI5kpEDoYqZD15cYYzQL7fWgE7Vy80Lx/k+sP6
wQuj1rTGuyJ1ndrzGkW2+INpf22y4rVmbscq3KTbXzKIofI9Vh8z65CamJKYieVn
nMEmFcVZBNQFhHzcDav/j3tcWmuJxN2ZU3IbSjY9C35wHxUSQKDDzWWwOAbemTib
/YdIGGJ/w3f0xsHxN6CK
=1++v
-----END PGP SIGNATURE-----

--=-cuBd8jiwTPxNlK17Ec4J--

