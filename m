Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767256AbXDETvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 15:51:21 -0400
Subject: Re: PCMCIA 802.11n support
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070405124217.42cf81ff@localhost>
References: <20070405124217.42cf81ff@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zJsDBVqzkjTkDXfz1aZs"
Date: Thu, 05 Apr 2007 21:51:06 +0200
Message-Id: <1175802666.3489.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zJsDBVqzkjTkDXfz1aZs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-05 at 12:42 -0700, Stephen Hemminger wrote:
> Do you know of any PCMCIA cards with 802.11n that are supported
> by the current wireless-dev tree?

I don't think there are any. We're trying to look at the Broadcom .11n
stuff but it'll take quite some time, and the only thing that is even
partially supported now is iwlwifi which I don't think exists in cardbus
form factor. But even then it's probably not fully supported yet.

johannes

--=-zJsDBVqzkjTkDXfz1aZs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGFVMq/ETPhpq3jKURAmrwAJ0QX2yNe9Y6hi7ZSiVORmD70bHlWQCdFcWK
wjl7GBv/0HQVsgOX+OWM66E=
=tBuF
-----END PGP SIGNATURE-----

--=-zJsDBVqzkjTkDXfz1aZs--

