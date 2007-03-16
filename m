Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40091 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965747AbXCPRHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2007 13:07:22 -0400
Subject: Re: question: /sys/class/net/*/wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070316150352.5290eea7@griffin.suse.cz>
References: <1172920691.4966.6.camel@johannes.berg>
	 <1172921257.4966.12.camel@johannes.berg>
	 <1172967669.3402.0.camel@johannes.berg>
	 <20070316150352.5290eea7@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8n+sDKBIczHijLm4cKSL"
Date: Fri, 16 Mar 2007 18:07:12 +0100
Message-Id: <1174064833.3355.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8n+sDKBIczHijLm4cKSL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-16 at 15:03 +0100, Jiri Benc wrote:

> > Actually, that was pointless. I should have checked before, but forgot
> > to, /proc/net/wireless lives in wext-common.c now which is compiled
> > whenever you have cfg80211/wext-compat and/or wext configured.
>=20
> Couldn't /sys/class/net/*/wireless be created by wext-common.c as well?
> (Didn't check, maybe it's not doable.)

Yeah, currently it just lives in some other place, but it could.

> Then we can have /sys/class/net/*/ieee80211 for cfg80211-based
> interfaces.

And /wireless just present for wext? That won't work out properly, but
I'm sure once I actually look at the code I can think of something.

johannes

--=-8n+sDKBIczHijLm4cKSL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF+s7A/ETPhpq3jKURAgd5AJ9oYxRhPn6uP0vqvHhyZ60ewVYMwgCfdmrQ
4NBf19xKXxcoc5ofbAJWYt8=
=Jtoz
-----END PGP SIGNATURE-----

--=-8n+sDKBIczHijLm4cKSL--

