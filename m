Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43642 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZAIMde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 07:33:34 -0500
Subject: Re: [PATCH v2 04/11] ath9k: introduce bus specific cleanup routine
From: Johannes Berg <johannes@sipsolutions.net>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Imre Kaloz <kaloz@openwrt.org>
In-Reply-To: <1231503868-29226-5-git-send-email-juhosg@openwrt.org>
References: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
	 <1231503868-29226-5-git-send-email-juhosg@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WgQNmo7JJR3/C+QbPCJW"
Date: Fri, 09 Jan 2009 13:33:58 +0100
Message-Id: <1231504438.3703.11.camel@johannes> (sfid-20090109_133337_686480_7E68BD54)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WgQNmo7JJR3/C+QbPCJW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-09 at 13:24 +0100, Gabor Juhos wrote:

> +static void ath_cleanup(struct ath_softc *sc)
> +{
> +	ath_detach(sc);
> +	free_irq(sc->irq, sc);
> +	ath_bus_cleanup(sc);
> +	ieee80211_free_hw(sc->hw);
> +}

Umm...

johannes

--=-WgQNmo7JJR3/C+QbPCJW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZ0QzAAoJEKVg1VMiehFY9YsP/Ror2b57BaaJqbzALnsfmOVA
SKo3RMKRHhJ+i++mkM5i70LvJ1icIBZwuxwAPrG5XntKCaRuKsMgG1AzahtT05/r
lc7Q9V1mG/mYooPhvD3WkTRuQlOxQQk2J3JaKuqYNY7KArWdLcbScNcoE9FYUlxb
g+wMIqdUb41PczUf1H09mEiBGJ9qeFZRy+YhiD+t/bGkOhxLMVpnmzSM+dOJuuX8
ItestZlMna73QV3gESQiOJ2eVmcekSKrCbDGWuEZ/UvcmruDUJlH76czCgvDqgNq
8rESg2KB5gwu/bqH5FRAsSpmdQ7j0HudwfdXNYT2TS4s5T/PMNmnlA+d9UDGt+GL
G5ai8wGRxhR4qxXq1pp+zMNalWVvIgN/N0/bMU9XCPe0mV07HeWSurZQYHaKxgUN
wO7Nhe5EGR5Wb0JPAu/aNfrjY0qsXBafZOBcAIawM9LwyPSVxC6VtDk4AG8oh4lk
5X4aLbc++PMombvOTRY93TjYYKDmmcfaqg4UK1v0nTYfN1oxdwrH4S/eG1xwNFuP
fHcZFqPs1OFX6AaEeiDU9smzZMMNjsMdwhaKf5WjpdmdTZBDCQ/0eaPSDZwcnov5
5t9Iot4obPXt1wabrTP1TSshoY5yuJ2i2vkd/OppO8IM54DnDYqkpKWrZ7f9cFUB
nMEe1e5YyBy3KPs6nTW3
=ZteZ
-----END PGP SIGNATURE-----

--=-WgQNmo7JJR3/C+QbPCJW--

