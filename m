Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41365 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYLATev (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 14:34:51 -0500
Subject: Re: [PATCH] cfg80211: fix wiphy remove if no regulatory request
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890812011101r3ad8225aofafdada8b5699535@mail.gmail.com> (sfid-20081201_200153_742533_C8FF06C8)
References: <1228129676.3478.0.camel@johannes.berg>
	 <43e72e890812011101r3ad8225aofafdada8b5699535@mail.gmail.com>
	 (sfid-20081201_200153_742533_C8FF06C8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VmT6wd+0rIdTJF6Yjo61"
Date: Mon, 01 Dec 2008 20:34:48 +0100
Message-Id: <1228160089.10627.35.camel@johannes.berg> (sfid-20081201_203455_471463_A2B13FF1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VmT6wd+0rIdTJF6Yjo61
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-01 at 11:01 -0800, Luis R. Rodriguez wrote:
> On Mon, Dec 1, 2008 at 3:07 AM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > Fixes the segfault I just pointed out.
>=20
> Thanks, the commit log should include the panic I guess though right?

Maybe, maybe not, it's fairly clear what's going on from the diff, I
think.

johannes

--=-VmT6wd+0rIdTJF6Yjo61
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJNDxVAAoJEKVg1VMiehFYXvEP/A+MtBE9J+/yN6Rn+NYV6wtH
8rvPxzzL1Ml4Yog4vNcxX5R2iwO0St0eUp/UQqTBSTUir4Pm5nIIuZJqHWr/abP4
Vyg1pxy0L55sMlFnSQipSYhwlRQhkuHk4yU0zzSYUxLT3rVbGqIWdomc07YNCEmi
qYMcobt07x/EtDnV9X0S5ySOpkTjNtg4c9IfkljKeUFwkq0FClmUQbWlmaiouzt6
VVXM8109I+yucUevw7kRokcPogNHdv13ru8xYhZyAikppRnYeR9cKlOU4oRMy0VQ
2gsWpWQUk9DcodtL8PJAMXmkC7f6EGb7EIYp6j+izOEYa0f6XknbL12srIkhllPv
6wzp0e0iIrf9Es2HZLV2hjczK189qMa/678hjEe7/oXiGtCzO78ZcT2hExUkkIn0
KlyZUuxVJLkV/iGA+QzVEiPRXP/tn8AeB4ciiZMd9DRwFgxrUQIKjzDXfTfhnhcE
C8F5/wCzWlPB+/kMV+AcdlP7/RGbLpqi1T5Bjyh4MAZy1iKipn5MVCIT7EBR6WL/
mp7IKE2sdn3Ua4Q8gj28ErSHvlKsCzEJ2vH8K0ubjVTzaHABOziSv4CqcBhEjrJH
RvSgIxloWv6d/LHi65Gtaqq4lZ/auv2Of3YggsMhHnXUO1B04FVtb6YvcQorFJik
h3fahQ/jojadNYASVcE/
=Mg74
-----END PGP SIGNATURE-----

--=-VmT6wd+0rIdTJF6Yjo61--

