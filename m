Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52358 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbXIQOvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 10:51:02 -0400
Subject: Re: iwlwifi testing
From: Johannes Berg <johannes@sipsolutions.net>
To: maximilian attems <max@stro.at>
Cc: Tomas Winkler <tomasw@gmail.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20070916171642.GB5280@stro.at>
References: <20070909165447.GA2574@stro.at>
	 <1ba2fa240709091000o3fecdcd4t301d715d864a1d95@mail.gmail.com>
	 <20070916171642.GB5280@stro.at>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PHC33hqmza33HAI/s38K"
Date: Mon, 17 Sep 2007 16:52:11 +0200
Message-Id: <1190040731.23521.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PHC33hqmza33HAI/s38K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-09-16 at 19:16 +0200, maximilian attems wrote:

> fixed thanks, another bugger:
> iwconfig wlan0 mode monitor
>  Error for wireless request "Set Mode" (8B06) :
>      SET failed on device wlan0 ; Device or resource busy.

first:
# ip link set wlan0 down

johannes

--=-PHC33hqmza33HAI/s38K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG7pSb/ETPhpq3jKURAjjfAKCN/vCmgJ40sDl6WLUq74/LwLUMsgCfe21F
leObqRh7BS23uYF+xGyiGKk=
=HLH9
-----END PGP SIGNATURE-----

--=-PHC33hqmza33HAI/s38K--

