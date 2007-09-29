Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104AbXI2MxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 08:53:11 -0400
Subject: Re: userspace mlme configuration (was: Kernelspace --> Userspace  MLME  move and related items)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1191068858.22960.75.camel@johannes.berg>
References: <43e72e890709281725n6a8ffe0bq487f32796a7e1cf2@mail.gmail.com>
	 <1191066581.22960.55.camel@johannes.berg>
	 <1191068858.22960.75.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j5hIrt0pjz2rNGHCGKaL"
Date: Sat, 29 Sep 2007 14:54:30 +0200
Message-Id: <1191070470.22960.80.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j5hIrt0pjz2rNGHCGKaL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-29 at 14:27 +0200, Johannes Berg wrote:

> 1) it is transparent
> 2) it helps us define the interfaces
> 3) it is UMLME-agnostic
> 4) it can support wext

5) There is no discovery issue

It is always clear which userspace MLME to talk to since it has to
register with the kernel anyway and it can be looked up by the network
interface. With alternatives two and three, userspace must somehow be
able to implement discovery to find the right netlink address/socket/...
to talk to for a certain network interface.

johannes

--=-j5hIrt0pjz2rNGHCGKaL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARv5LBKVg1VMiehFYAQKAWA/6AwO3O5+PBA3nIWP2USEBSZpX3ucOmefa
V0khzHjCYiv+cS/MG0WXGPmrjfwzsKhnBagA0solbWwZrBWMzrNRQ8L9y+r80wuC
SAFYPPBblHJVkUZIcSaZdHRv7K0SR4lLvBkMH9lw02LsWxLJX+4RzUZI9pBmLgPx
K4kxmWqGk35ZTEyxuEisU4eOegKIOPw6RmtEvhdW+/AMVRu0qfdSsyMtIxRPMKXh
ImM16ZBLpL4pufBdZuRpQvfbsMzSytDpHj+5MhVkfkOGt+B5iQa5n0R8A457GWwF
SdTZsW4PkjVAXlArqAyDTVPX9EXzojFNeib8QWFzuzf3vNH0VTItYD1mjz9NxYFt
Sc/WhFR/xWNESkjeb5RUTVkOxFKdUcDTjeeTvxqfaLroEnk5HKT200w5lcIAq+S1
sPevBoK89mZjoWTGGOSxJf4D4OdLp4GAjuWc/BPSVplMnuPDh1iKOdJ05P85s65+
aLMccV/nisdigCYIGuOotfimRL/ss8EXtM9sAq/0bZDNl/SLVbPm8zZrA599YiyX
lJ1UUAtX798UDj1Ds4Amo0zNZvh+725UXPde5ziab+7oiR0KKbim0tb2XTysWJiD
/Ccj/Z4cYlfxH23A/77plZ/xQDOt4iPseGXtANe3hCeUX0iffzfURcbtlBGvlSxX
ypWy+ZI2TuE=
=+X7L
-----END PGP SIGNATURE-----

--=-j5hIrt0pjz2rNGHCGKaL--

