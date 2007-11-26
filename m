Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXKZQ1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:27:05 -0500
Subject: Re: [PATCH 01/15] mac80211: adding MAC80211_HT_DEBUG config
	variable
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <11960864902505-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <11960864902505-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yNQe2KBQPEB31odaXpAN"
Date: Mon, 26 Nov 2007 17:26:56 +0100
Message-Id: <1196094416.4149.291.camel@johannes.berg> (sfid-20071126_162710_278939_904CFEFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yNQe2KBQPEB31odaXpAN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-11-26 at 16:14 +0200, Ron Rindjunsky wrote:
> This patch adds MAC80211_HT_DEBUG config variable
> to separate HT debug features
>=20
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/Kconfig |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index ce176e6..09711b0 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -51,6 +51,16 @@ config MAC80211_DEBUG
>  	  If you are not trying to debug or develop the ieee80211
>  	  subsystem, you most likely want to say N here.
> =20
> +config MAC80211_HT_DEBUG
> +       bool "Enable HT debugging output"
> +       depends on MAC80211_DEBUG
> +       ---help---
> +       This option enables 802.11n High Throughput features
> +       debug tracing output.
> +
> +       If you are not trying to debug of develop the ieee80211
> +       subsystem, you most likely want to say N here.
> +
>  config MAC80211_VERBOSE_DEBUG
>  	bool "Verbose debugging output"
>  	depends on MAC80211_DEBUG

--=-yNQe2KBQPEB31odaXpAN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0rzz6Vg1VMiehFYAQK2QBAAjZV+Y/iHkNzPY3HLM5DUSjgTIqcG/qoB
TOA6X3qS+yPr8OZCZY5N28xa6TCLV07zplyFvHUkuiEgDoGwa6H3kXtL5ucKuYY/
MHMsnViNRfc/AIfEDHjsvq3EqCEQFI0gqNaYacHzir7Oo7D3OEbHBlVvKoqbSxrq
Se1/hOiDcf/yoOiCoVjLuCHh9NtPrXZ1TcQUcA3w605T85FW0gXXwREHRZkC8ZBj
x73jF9nARVpCC3h5Xo+CBI3l0pyHhuW2lnSgPnxcnEWAz8zZOoU1+mio+Ld7K8W+
169E4Qh2VuB/hJawijfh0tjfTGpg6s7ewCMTXk55eRaRasFUSuvQio6GxKrIttMa
KUJEfXImGr0q0jFwGDhqd7GJ6WJWKgVrK3VKJ1Bf1EM/4F11RU6W5btJf+ZBEZJ7
4n9G46mv2EP7Yz99se1GGU9M20xtYKoR9gDEvWC5cmO+ZkXmi+si6Tk/RuZztIlg
oGWF4K++ibceFvYul5WtJc2TZgiNV+GzhLXhY1hdZaC623U+lI9xisLwwEVfiAsN
BON3FNaBQX+uSqgYhsoFWlUIwRAJIuMUfOdMvHdNxu2mJKm0jsx3lpSS14jZZxr9
+XWKoUEUHncV7u4Tw2mIPghGBd7indFHPWAz/FpPXgb521o+zRXRS8b+LU+0MT1l
dxoU33EnLqg=
=U4dm
-----END PGP SIGNATURE-----

--=-yNQe2KBQPEB31odaXpAN--

