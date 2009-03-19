Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877AbZCSVq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 17:46:56 -0400
Subject: Re: [PATCH v2 0/6] Use the regulatory bandwidth and export HT40
 stuff
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090319204406.GA14753@tesla>
References: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com>
	 <1237491647.5100.114.camel@johannes.local>
	 <43e72e890903191328j15a53a5au1f0162e53daa2a14@mail.gmail.com>
	 <1237498852.5100.121.camel@johannes.local>  <20090319204406.GA14753@tesla>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SGlItAgALKQXs/f88f77"
Date: Thu, 19 Mar 2009 22:46:51 +0100
Message-Id: <1237499211.5100.123.camel@johannes.local> (sfid-20090319_224658_305934_0A32E9E7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SGlItAgALKQXs/f88f77
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-19 at 13:44 -0700, Luis R. Rodriguez wrote:
> On Thu, Mar 19, 2009 at 02:40:52PM -0700, Johannes Berg wrote:
> > On Thu, 2009-03-19 at 13:28 -0700, Luis R. Rodriguez wrote:
> > > On Thu, Mar 19, 2009 at 12:40 PM, Johannes Berg
> > > <johannes@sipsolutions.net> wrote:
> > > > John,
> > > >
> > > > please back out this series, I'm not sure I agree with the concept =
and
> > > > I'm sure there are potential bugs that can make it segfault.
> > >=20
> > > Can you be more elaborate?
> >=20
> > reg_process_ht_flags_channel doesn't initialise channel_before and
> > channel_after.
>=20
> I can fix that, two lines.

I know, but I wouldn't want having bug reports from this code until John
gets to merging again :)

johannes

--=-SGlItAgALKQXs/f88f77
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwr1IAAoJEKVg1VMiehFYo2YP/0GKED0Gbzx5GM22QvDGRCyu
CbtgpdDsu9jQgoOkAGiktp0+Dw0HGDekwpVqkIqLhSLqWsNp13EU4xlV2i3AAORS
6fgtcIPwicCB2ksmh8wu+jrSAs8RN7QWEZx8p/usMBOWsYUhwRqopE1dGhjagD+I
AGqtmNyCoj5yQ+1RSm+eSi/zlQOrXmooVlgiXLzBm+ito5WZ+RjRBSMazA6rE8+2
T3w0Gz7K++3pRPQQC0BgEo8TnBB8KF1sje/vQ9qEKsT4aw7BXflhbzdEl1CXiWQD
V+W7YcsolT8vDJFH8RzSZboHUFMfZYNWphobPuGXMM/qDK2aCSgNPRKZrelIp1rJ
0uHw4zZ0uy7SiVdDfKVYQj8TxwmtEz5smCW4/Bhytty+s4Tx7TF9n9wjFnELf94T
IFtPlgrAkLYLH+zOARMt/fDGF3t0UCI/fnJNCHOsuXndVdvPQEL8Y6tCokslL/jh
2HI8mQv0BcpWCICix9ZOHniiIUWUPPyYHhm5fP3LP7X6YKfAjQsofwmCA0aVAKWS
hRu69pqobxGQkj4HGVoIW6kTqhTcPFarISnZ8rahOUDyP4iAblZrxAOTJStq7xV4
X/mKawAarqSEIdp0pl/OQkOBtHiJr684G+LYt5ohLH71z7E83iY3cIT6DrIuaofs
7NGobeOD7PhDJg6YqABd
=l5zy
-----END PGP SIGNATURE-----

--=-SGlItAgALKQXs/f88f77--

