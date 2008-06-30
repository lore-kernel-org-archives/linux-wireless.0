Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163AbYF3LGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 07:06:33 -0400
Subject: Re: [PATCH 1/1] mac80211: don't accept WEP keys other than WEP40
	and WEP104
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: drago01 <drago01@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240806290257r1db0e021n152945d41ffe2f42@mail.gmail.com> (sfid-20080629_115722_351612_5A52EE51)
References: <1214610613-6990-1-git-send-email-tomas.winkler@intel.com>
	 <f6ca9fed0806272346y2e8fde2cwa27a79ee83d0c0af@mail.gmail.com>
	 <1214639847.5507.6.camel@johannes.berg>
	 <1ba2fa240806290257r1db0e021n152945d41ffe2f42@mail.gmail.com>
	 (sfid-20080629_115722_351612_5A52EE51)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hxnnUfk0h2ux0bXU8CBB"
Date: Mon, 30 Jun 2008 11:25:05 +0200
Message-Id: <1214817905.5507.29.camel@johannes.berg> (sfid-20080630_130642_210366_16D24FFC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hxnnUfk0h2ux0bXU8CBB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I don't think zero-keylen will have WEP there, will it? I don't really
> > know though.
>=20
> This patch  pushes the length check to ieee80211_set_encryption.
> Unlike John's patch
> where check was done in ieee80211_ioctl_siwencode.
> The benefit of this is that both ENCODE end ENCODEEXT are treated.
> The zero length key i.e. changing index is already taken care of in
> ieee80211_ioctl_siwencode

Alright, thanks for the explanation.

johannes

--=-hxnnUfk0h2ux0bXU8CBB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIaKZtAAoJEKVg1VMiehFYyH4P/1fbwqcVGCo07/01a16lU8S3
sI7STQiGRfQSGJTa5kJHzn/ve5+DzyEQsveUDf7T3FdSAqVuWcwCBuPEpar3T0zf
+eE/qf+SXeyj0Mo0WaP539exqulaBQV8mnJkFXkdBIeBCSna0hmwvChud11d0vaH
wHJLhhB3syVF9vWQwTms3BfWVjuU0cA++5G0vvK6FNhIB8nbUokAu7tmJtzDuSbn
d9VOt/V3QCsBrVoUuQ9Uydz9i89mg4RgBsPJLkFiYVg8ehT0zwczc6O7+/Fi0xTd
J8/pFgqL4Tq7+qPlAp4FT9gIfXha8V2HdrzWgRH2AX8Cgm0+b8yM2QkXSwleoWOS
DOa6W8+QUp898XWlgfzigpsIrQEnGNdAuRu5/K9GdTgbk5irT0OdygnH9gvD8gQY
rzXEL1D/ygJrQQ/vRXlNtGJSGZexiu3fHtVJCcLAAA/HdIlaZ0Am6wC9dIUIuQt+
1xHTmM5XpwkOFEsz/CJaHF0vmy49jXQ7HpZqIvyOjp+io8iax9KCgjuE2t65STZ8
xdXNa0GEAYizrC1joaVwxm5uk6QvlZTufRxDnthEdyPxkvq76caSm81ZG5XHWdLo
MFbSjtZBqEVLrkqMjbAAuDoIyLN50jzxSkLA0cg+TU9DZ+mwuF8BzoXF5WfCioOK
XZYTUeMHaGHx/hbJACra
=vvr6
-----END PGP SIGNATURE-----

--=-hxnnUfk0h2ux0bXU8CBB--

