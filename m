Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49419 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844AbXC3Kj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2007 06:39:28 -0400
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and  association
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	mohamed <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <1ba2fa240703291648h6b0d10bdje2ea54f3c1754f5b@mail.gmail.com>
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
	 <1175112213.5151.133.camel@johannes.berg>
	 <43e72e890703291246p1010770es9d8a81979d03fa72@mail.gmail.com>
	 <1ba2fa240703291648h6b0d10bdje2ea54f3c1754f5b@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/7DzieAnHOiFO0ONTQ0A"
Date: Fri, 30 Mar 2007 12:38:32 +0200
Message-Id: <1175251112.19085.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/7DzieAnHOiFO0ONTQ0A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-30 at 01:48 +0200, Tomas Winkler wrote:

> Can someone  explain to me what is rational to choose between  making
> information element (IE) a struct  or 'rolling it into the code' . I'm
> finding it much more readable to use struct and when it  changes for
> example because 11n draft changes. And the change is reflected in
> compilation time.=20

I wasn't talking about making it a struct or not, I was merely saying
that there isn't much point in a three-line function that does
essentially nothing related to the actual task.

johannes


--=-/7DzieAnHOiFO0ONTQ0A
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGDOio/ETPhpq3jKURAsYQAJ9MGUOnEfiEbehGPTEU/V+03cTYoQCeJ2D6
h/RrkQvuTo7Fy1Ge2GL+510=
=6FNh
-----END PGP SIGNATURE-----

--=-/7DzieAnHOiFO0ONTQ0A--

