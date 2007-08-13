Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S972280AbXHMMl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 08:41:29 -0400
Subject: Re: [PATCH 1/4] Net: mac80211, remove bitfields from struct  ieee80211_tx_packet_data
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	jbenc@suse.cz, flamingice@sourmilk.net, jeff@garzik.org
In-Reply-To: <32694265142306417777@wsc.cz>
References: <32694265142306417777@wsc.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7G5E77YaV8ejdTKXdGhu"
Date: Mon, 13 Aug 2007 14:43:49 +0200
Message-Id: <1187009029.27916.107.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7G5E77YaV8ejdTKXdGhu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-08-12 at 15:08 +0200, Jiri Slaby wrote:

> +	if (control->flags & IEEE80211_TXCTL_REQ_TX_STATUS)
> +		pkt_data->flags |=3D IEEE80211_TXPD_REQ_TX_STATUS;
> +	if (control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT)
> +		pkt_data->flags |=3D IEEE80211_TXPD_DO_NOT_ENCRYPT;
> +	if (control->flags & IEEE80211_TXCTL_REQUEUE)
> +		pkt_data->flags |=3D IEEE80211_TXPD_REQUEUE;
> +	if (control->type =3D=3D IEEE80211_IF_TYPE_MGMT)
> +		pkt_data->flags |=3D IEEE80211_TXPD_MGMT_IFACE;

This looks weird. Can't we just use the same flags?

johannes

--=-7G5E77YaV8ejdTKXdGhu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwFIF/ETPhpq3jKURAjXCAKCg1zYXY3Xvcl8v4bea/6pHod8yUgCgorwG
DaD5jjbBjNVxZdrxjVy9OMY=
=Wwrs
-----END PGP SIGNATURE-----

--=-7G5E77YaV8ejdTKXdGhu--

