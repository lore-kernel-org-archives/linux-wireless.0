Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37356 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbZFAPiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 11:38:01 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090601153620.GB15485@khazad-dum.debian.net>
References: <1243763887.19302.29.camel@johannes.local>
	 <1243796509.6570.35.camel@localhost.localdomain>
	 <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk>
	 <20090601122839.GB11011@khazad-dum.debian.net>
	 <1243859931.5299.17.camel@johannes.local>
	 <20090601124553.GE11011@khazad-dum.debian.net>
	 <1243860606.5299.21.camel@johannes.local>
	 <20090601133351.GI11011@khazad-dum.debian.net>
	 <1243866545.5299.25.camel@johannes.local>
	 <20090601153620.GB15485@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UCWQe2IkDIPHHnUsAbp+"
Date: Mon, 01 Jun 2009 17:37:49 +0200
Message-Id: <1243870669.5299.29.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UCWQe2IkDIPHHnUsAbp+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-01 at 12:36 -0300, Henrique de Moraes Holschuh wrote:

> > > On a related note, Johannes, would you be opposed to exporting someth=
ing I
> > > could call from thinkpad-acpi to request a radio state change on a rf=
kill
> > > struct?   This would allow me to remove some of the mess in thinkpad-=
acpi.
> >=20
> > I don't think I understand what you want? What do you mean by "request =
a
> > radio state change"?
>=20
> As in "please try to block this _specific_ radio", and "please try to
> unblock this _specific_ radio".
>=20
> I.e. what one would do by a write to the "state" attribute of the _old_
> rfkill sysfs (and which would get overriden the next time someone changed
> the global state, etc).

Ok, but where would you want that exported to? It's available
on /dev/rfkill, why would you want that for the driver, it can just call
itself, no?

johannes

--=-UCWQe2IkDIPHHnUsAbp+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKI/XJAAoJEODzc/N7+QmaNNwP/3YWZOpYtMqnWza16qGVvPD4
wldduM4nfHHOat5ggMH0eLX0+5MgJfJOE0ghR5cgK1K8iRv0USyjnAWmodQgTwhb
iRTTk8+X+4MdFmfCdJYMvSsF7Xzrxily1vGZzX8K2+30T5uJvkOJ2LAJzc/jQn7o
vwztqROco1yNnfuRURPWX+0fCo3UgLhwcDcLy+ReYsfioPySd6at/EbnKBN9qNlO
1QLbxYnD4NGELF1c+nxwAraHfgjxSS982s0kwUQQNF/TZnARC+9nfysjJhy9d2Dj
07BHW0bMTbitrk5MPLObYKOjyjDaqUNqcvEmaBaeIkph9TS+HHHuw7h8gsLCZC1c
TFgXVf6PCS54rL8p5hpVylUlGV6780/SuXCU+uzMwqG3qyEDppFouR1aE+wqnXmT
EIyk9/M7kYfIhgj3piWKllkaIJSJeyAIOA06Ar7UllIJ5CXKHIvgHcUJIs0DwyRF
KAgQfff+NBi8880sb4SdYuADkU42ocypVeO+EQzkEiDjdmWzVhAGfV5HckhvyLow
tXlE+b+rdMmwvpJIE8AjDYSe6R3/NKfEtaHQmD1H90ofbwrCFA25zHDAntVSf/IU
7Sp98j4KT+hEruebYVG521wA2QHmucS5baLdD98xH8gHmyIyGrTc/XBnbSeesgGv
Ogo2f4arzkXsvO6zb/+e
=Vs+H
-----END PGP SIGNATURE-----

--=-UCWQe2IkDIPHHnUsAbp+--

