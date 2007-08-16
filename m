Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49513 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbXHPNLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 09:11:12 -0400
Received: from [131.234.209.34] (helo=[131.234.237.45])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ILf83-0001xH-09
	for linux-wireless@vger.kernel.org; Thu, 16 Aug 2007 14:11:11 +0100
Subject: Re: [RFC 2/2] mac80211: revamp interface and filter configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20070815152658.587906000@sipsolutions.net>
References: <20070815152557.221351000@sipsolutions.net>
	 <20070815152658.587906000@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-I5ihvhJMNFGcLjEYEVh+"
Date: Thu, 16 Aug 2007 14:41:04 +0200
Message-Id: <1187268064.5141.22.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I5ihvhJMNFGcLjEYEVh+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 17:25 +0200, Johannes Berg wrote:
> =20
> -	/* Device is capable of performing full monitor mode even during
> -	 * normal operation. */
> -#define IEEE80211_HW_MONITOR_DURING_OPER (1<<9)
> +	/*
> +	 * Device has multicast filters.
> +	 */
> +#define IEEE80211_HW_MULTICAST_FILTER (1<<0)

Well. That should be (1<<9).

johannes

--=-I5ihvhJMNFGcLjEYEVh+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxEXg/ETPhpq3jKURAoWNAJ9rVv1Ev7M+19XFcuhugMpXB0iq6ACggV9a
SNRLQwq9RjnwlnRj3hr4PLo=
=gEv5
-----END PGP SIGNATURE-----

--=-I5ihvhJMNFGcLjEYEVh+--

