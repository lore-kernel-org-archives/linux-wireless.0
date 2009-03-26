Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663AbZCZOql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 10:46:41 -0400
Subject: Re: [PATCH] mac80211: add driver ops debugging
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b6c5339f0903260741i33264d5dy5e48a5c182cce387@mail.gmail.com> (sfid-20090326_154225_798169_2EA7388F)
References: <1238066858.4331.30.camel@johannes.local>
	 <b6c5339f0903260741i33264d5dy5e48a5c182cce387@mail.gmail.com>
	 (sfid-20090326_154225_798169_2EA7388F)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sSEtGMONYg2OS62OeJyE"
Date: Thu, 26 Mar 2009 15:46:02 +0100
Message-Id: <1238078762.4331.38.camel@johannes.local> (sfid-20090326_154656_216088_403F0CAB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sSEtGMONYg2OS62OeJyE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-26 at 10:41 -0400, Bob Copeland wrote:
> On Thu, Mar 26, 2009 at 7:27 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > This patch adds (optional) debugging for each driver call
> > (except tx) that can print out the call, its parameters and
> > the return value from the driver.
>=20
> Could we use some newfangled thing like tracepoints for this
> instead of printk?  Disclaimer: I know nothing about such
> things.

Probably. Want to look at how to do that? :)

johannes

--=-sSEtGMONYg2OS62OeJyE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJy5UnAAoJEKVg1VMiehFYZxIQAINNns8L+bPt3l/YTB+UcY7+
EcQpQ7BbD3IRzW5v3mhmJXrUB0IEdu9bi6+7amN8KC6lnL6eHI8uwUPvapQ90BpU
+nPhijidNkVXGfatXrhbN9ZHtZN3kKpCw4lbDj69C6UNCEPNlWbpSYwlI0NWfZ+V
5P/gvWyK4m1nRA0UELZhfbpVN5SdYbNQChtEXwhIlfOUC1FJXdFqEIOOZ782tWvd
99mu2LBi/NvH0akNw6lcF3wLOeGVfprfmXHGDwCVKmsiUb+GlEdDnQ3QbLfV0xjx
sJbyPbYCc+HDVoGWD/Bsd+iZgnQkycIkJz3fpFcB082zxC4gGbhdFAW8XUfZdcWw
81XmfSvBKlUz6+/sGEihp5UiMUJdYIQ6BWSz4sMtxiUt4lRCgVDEVlH9BPDDWBmb
IfpmPp2h7AIlcSlzralOzjl1zncqLgtFYVeVlFUTcdhjPHTwACmlkV2m0u5ShMRo
ZdwenJJb2VKR1BoS7Vr3UjzfUkeVO+qZfbekIZQiNXT4ywdvIWNsgLuvzVOsdvU/
VRsadbMAu29FxZ3gJECc3Lpw1oo3kOgaK19si4B26UgYvMd4hx3BXTb4p/T5UgOg
SpbPSUngfHOK6qj550eE21F5QIStVcW8AWcWyoL72FF832AV3otBcPKIEYk1D19z
6T3UquhT0GVlFeTXXtlT
=FqX4
-----END PGP SIGNATURE-----

--=-sSEtGMONYg2OS62OeJyE--

