Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53852 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbYAJMPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 07:15:14 -0500
Subject: Re: WMM QoS classification with local bridging (bridge_packets=1)
From: Johannes Berg <johannes@sipsolutions.net>
To: Guy Cohen <guy.cohen@intel.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <247d6d340801090503k289902afwd9fc22dbb4a1e70b@mail.gmail.com> (sfid-20080109_130401_569599_6C500E5B)
References: <247d6d340801090503k289902afwd9fc22dbb4a1e70b@mail.gmail.com>
	 (sfid-20080109_130401_569599_6C500E5B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-giL98lmn3zFk8dh8UceM"
Date: Thu, 10 Jan 2008 00:58:48 +0100
Message-Id: <1199923128.3861.45.camel@johannes.berg> (sfid-20080110_121525_639954_90D85932)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-giL98lmn3zFk8dh8UceM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> What do you think is the right way to fix this? Parse the frame in
> deliver_skb and set the protocol to be IP (when IP frame), or leave
> that as is and in classify_1d parse the frame instead of testing the
> protocol field?

Can you explain the spec requirements? I'm mostly ignorant of the
11e/11n specs. It seems like if the TID should be preserved we should do
that regardless of whether the packet is IP/non-IP so neither of these
solutions would work. But maybe that's not what is required?

johannes

--=-giL98lmn3zFk8dh8UceM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4Vft6Vg1VMiehFYAQJ4ARAAkOc4JdmEHhuQ3f/pjy4fdIM9ww45MUQO
QzstfBYsoEkUGntvEdM5Zx4KMUvJGlR4YSGwhda5/IqbO/ZupkCqs+0sOW6Feh+D
GPQIhQ/GNbFEm3MMFXj8DnaqB4IVcY61Ae3d7lXbO8/TDCp376NSSMjanjsr6ZIM
4UuClAFrXZj7FA7ORmsZBq5ssKF9/R4Oj1bb1QyuItWGpW377AzI4+k17kBlOXrG
oCae6lWS1Ph9EiFObQJkhTu8sl/3NWsrt5dIiylYtwljK1dZed+GC1Xl64zyr6xb
RbWhLxDxQ28gqwR0CCspHVIN0p8sA2D2nIvbC4z2x/MkDT3LaLeLppLHEwzG1dA3
o4LrEAyBgKM/neAmykJSDKyGnBcbUz+XkWu/IkHvLVbhmCxUS2hlwu1W6NAE+bBP
3aDuu21o+lLYpy90Ld5rVKNEpGtEDbKmca5WexlZHVOGwvZlNb1igY2kZUfRFpGE
lSvV0aEmFyLa6t1J45qPQRhwgMPxihfonygEq7B+UXgJrZuT5wSiuejaM7jmGJhi
RexvOHN/U6trx4AHCCfPpsBfWHse6oqyfzHto36IE9d0Fu40Y7SstdTaUazwO+1T
ZcVisbv0oIF0UvABdA532tv2WIvZO09P5gEwNMMvOoUl4nA+CohADlDM+Q9hYf+j
4QX/A5wO+50=
=uvms
-----END PGP SIGNATURE-----

--=-giL98lmn3zFk8dh8UceM--

