Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965375AbXDCLsY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2007 07:48:24 -0400
Subject: Re: SIOCSIWAP behavior question
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1175541560.11325.17.camel@localhost.localdomain>
References: <1175521655.9859.15.camel@localhost.localdomain>
	 <1175533095.23438.79.camel@johannes.berg>
	 <1175541560.11325.17.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JQzhgqzwcqr/5arDhvDW"
Date: Tue, 03 Apr 2007 13:47:46 +0200
Message-Id: <1175600866.16379.40.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JQzhgqzwcqr/5arDhvDW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-04-02 at 15:19 -0400, Dan Williams wrote:

> So it appears that you and Jouni have opposite views here?

Looks like :)

> I think a
> pure & consistent approach would issue disconnect every time the driver
> disassociated.  But I'm not sure that would actually work in practice
> for all cases.  But I don't have a good idea of all the specifics or
> implications.
>=20
> I tend to think thought that Jouni's right and that within the same ESS
> we shouldn't send disconnect events if you're just changing BSSID.

I guess that if you just send a new BSSID without sending a 00::00
inbetween the disconnect must have been there and is sort of implied.
I'm fine with either way, and I'd like the outcome of this discussion
specified somewhere on the cfg80211 page on linuxwireless.org so we can
do it that way there too and I don't forget ;)

johannes

--=-JQzhgqzwcqr/5arDhvDW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGEj7i/ETPhpq3jKURAsQcAKC6LdMKMJFwf0401TOOu/KoEZnxAgCfV726
sveGdSwdRu3Vrtd6W69gFbQ=
=baLS
-----END PGP SIGNATURE-----

--=-JQzhgqzwcqr/5arDhvDW--

