Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38717 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab3BMOrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 09:47:22 -0500
Date: Wed, 13 Feb 2013 15:47:16 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 1/3] nl80211/cfg80211: add radar detection
 command/event
Message-ID: <20130213144716.GA24508@pandem0nium> (sfid-20130213_154725_605161_10732A00)
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <5107D345.7010101@neratec.com>
 <20130129143652.GA23425@pandem0nium>
 <5109094C.8050703@neratec.com>
 <20130130162531.GA27532@pandem0nium>
 <510A30D1.2080604@neratec.com>
 <20130131175429.GD2018@pandem0nium>
 <510B942D.5000403@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
In-Reply-To: <510B942D.5000403@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--huq684BweRXVnRxX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Zefir,

On Fri, Feb 01, 2013 at 11:08:45AM +0100, Zefir Kurtisi wrote:
> Note: removed folks from CC to reduce noise
> On 01/31/2013 06:54 PM, Simon Wunderlich wrote:
> > Hey Zefir,
> > [...]
> >=20
> > Thanks a lot! I've got quite a few mails of people offering their help =
to check
> > and verify this implementation or test it in their country. :) If you w=
ant to
> > help in the integration for ath9k, I'd be glad ... the interface should=
 be
> > rather simple so maybe we don't have too much hassle? I have a little p=
atch for
> > ath9k to add dummy radar support and simulate events etc as baseline, i=
f you
> > (or anyone else) is interested ...
> >=20
> I am currently bound to another project (interference detection based on
> ath9k-spectral ;)), but since I started integration once long ago based on
> Victor's initial interface proposal, I might take a look again (if noone =
else
> wants to try).
>=20
> Do you have the updated driver interface ready?

As the nl80211/mac80211 part is merged now, I've sent a implementation refe=
rence
patch for ath9k [1]. It just adds a debug file and claims that it can suppo=
rt DFS,
obviously you have to enable radar detection and hook in your dfs pattern d=
etector. :)

It would be very nice if you can give it a try. :)

Cheers,
	Simon

[1] http://permalink.gmane.org/gmane.linux.kernel.wireless.general/104056
>=20

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEbp3MACgkQrzg/fFk7axaXhACfezm0S3yIM5SWEua+C0VPCjv0
y84An101n/6l3qghcfGVdkY27r0xUUZF
=p1r5
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
