Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45447 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190AbXDLJFp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2007 05:05:45 -0400
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and  association
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Simon Barber <simon@devicescape.com>,
	Michael Wu <flamingice@sourmilk.net>,
	mabbas <mabbas@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <jkm@devicescape.com>
In-Reply-To: <461DF586.6050009@warmcat.com>
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
	 <20070411194059.GA2436@tuxdriver.com> <461D3F48.70004@linux.intel.com>
	 <200704111630.06160.flamingice@sourmilk.net>
	 <1ba2fa240704111503l6dcef504na73c997ae75ebccd@mail.gmail.com>
	 <C86180A8C204554D8A3323D8F6B0A29F01DEB33D@dhost002-46.dex002.intermedia.net>
	 <1ba2fa240704111605l305230d3vf09c085473364eb3@mail.gmail.com>
	 <461D6E4F.6060401@warmcat.com> <1176368209.7052.10.camel@johannes.berg>
	 <461DF586.6050009@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7HOBx3QgcRmva90sUgLs"
Date: Thu, 12 Apr 2007 11:06:46 +0200
Message-Id: <1176368806.7052.15.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7HOBx3QgcRmva90sUgLs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-12 at 10:01 +0100, Andy Green wrote:

> Just curious, why is that evil?  It seems if the usermode MLME is=20
> interested in what are basically Out Of Band 1Mbps management packets=20
> that share the same air as the payload packets and so appear on Monitor=20
> mode interfaces, then a local OOB class of packet doesn't break such new=20
> ground.  And it does neatly fit the communication semantic already used.

Oh but those aren't *really* fake then. In this case, I'm ambivalent,
but the stuff we have in there for some things like radar notification
is just ugly.

johannes

--=-7HOBx3QgcRmva90sUgLs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGHfam/ETPhpq3jKURAqyuAJ9Q/6k9I9dsjoQUfYvNjRlV3PilJgCfaKeb
OWrwZ/UlkYhw7gkmzWDgP6I=
=FLPK
-----END PGP SIGNATURE-----

--=-7HOBx3QgcRmva90sUgLs--

