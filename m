Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbXKVPqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 10:46:43 -0500
Subject: Re: mac80211 regression: doesn't associate automatically
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1195746110.4149.23.camel@johannes.berg> (sfid-20071122_154157_592128_8A51A962)
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <200711221514.37906.hs4233@mail.mn-solutions.de>
	 <1195742483.4149.6.camel@johannes.berg>
	 <200711221605.55506.hs4233@mail.mn-solutions.de>
	 (sfid-20071122_150536_458314_211D8F87)  <1195746110.4149.23.camel@johannes.berg>
	 (sfid-20071122_154157_592128_8A51A962)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Dzf7PL1Lq1yLAG1lsgpp"
Date: Thu, 22 Nov 2007 16:46:39 +0100
Message-Id: <1195746399.4149.26.camel@johannes.berg> (sfid-20071122_154645_742033_23D77BB3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Dzf7PL1Lq1yLAG1lsgpp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> It *does* matter because the only thing tools and people using the tools
> can rely on is what is defined rather than "happens to work with driver
> XY so it must be right"

In fact, the *ONLY* think wext defines (via iwconfig's man page) is that
setting an AP mac address forces association. Everything else is being
nice. Hence, to be absolutely compatible you should *always* issue
"iwconfig <dev> ap any" after setting configuration.

johannes

--=-Dzf7PL1Lq1yLAG1lsgpp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0WkXqVg1VMiehFYAQJVshAAi2yxwsCxgvfJFcQ12+p9bMvVkbzWrX3f
ESPHCplcIRlWZ3O5QQbHyvbCDkEyatyQXKAUpm3lIPDiaag7D2HnXAW39P4wFoE0
4OduXTi2ejB3PZyHS6SCyQNshqh6Jbk/e90t6Z2f0cH/LudgHAWX6YBoW8cixnmf
vzKtNuKPZh8jc/WsAGVByQ2faPzzpRfN1xR3/ELvPAk0BdMj1yfi8l2BVToYEzU7
dY5opWp+fIk3TkON43QWjGdfka6TrFpRgZu0XkDfOsY28wUZgcGyJVeSSFohwvTv
cELNq94IlP6xwQ9+M39egotlJ4+3k5GRfOzFvmmHpvm6j/Vaf0VU3EqZ9fWILEzf
8qc3KV60GFXBQ6n9qw4jalEyH2JIZWxaKf0a49vu2NdDmoG1DGNf1iMEZ3ZaVw6l
/oANGPgWIASZNhkkyucpG83r2+tZm3HnE6ZethlK5rMzLq5nNOdAuzapV7ke8gte
156/Hfn6/aUfCNaUyhjBleRVyrHeV9xBSdlCqxkKtTMjg+N9IwaubN3kcRmaZ51Z
XspJ+IDDQhN7/I4+yfygqjM+3yA3eamDMEIcAnOENuSY+hWT6pQCmPdp3eLNIZL0
DLI4FDJUxSH89RNz1CVBAQyu3ibs0ULcQhoe98wewtPdqu9SLRFWn2Y/K6eixwEH
fbtLvr1cb24=
=U0IG
-----END PGP SIGNATURE-----

--=-Dzf7PL1Lq1yLAG1lsgpp--

