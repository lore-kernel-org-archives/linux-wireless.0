Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37073 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZIBQst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 12:48:49 -0400
Subject: Re: [PATCH 2.6.31] iwlwifi: Reenable power_level
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Andrew Lutomirski <luto@mit.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1251906970.13180.137.camel@rc-desk>
References: <cb0375e10909020753o4d314f61k74dd35025f61666a@mail.gmail.com>
	 <1251906970.13180.137.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ao8NfL0RDu5IMKwt88uh"
Date: Wed, 02 Sep 2009 18:48:03 +0200
Message-Id: <1251910084.24846.29.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ao8NfL0RDu5IMKwt88uh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-09-02 at 08:56 -0700, reinette chatre wrote:

> 2.6.32 will have power save support disabled also.

Only by default -- there you can actually enable it as a user with
"iwconfig wlan0 power timeout 100ms" to turn it on -- unless that patch
didn't go in?

johannes

--=-Ao8NfL0RDu5IMKwt88uh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKnqG/AAoJEODzc/N7+Qmaqu8P/2CsRlzupU3jLYEwKy8+6xpR
1mhzxlYOTKa+j4+OmphSByBkWRCnymbd+rN8nqi/A60q2z2rWnHUMCoWaqMYzTHq
9Z0V4rC65kOraIiqJgOsLJvh1QAowW3Zhb42FtaPZmb679CnOmb4bkhvmww1wUo8
RFfDVI5fIOUyzJlqbkGKnDWLqOPYiL1L+mdnOaReK/YYDWphXvoIQ6EqLN26r2q1
VC1pV+eeQrvE1mnig7OxJ/gjSUMMO3kuvmcV83a1wkq+rTwb7WzOF4ldb5p+Y7F5
W5BVY10jNnFjqHcoUl96q0x5rPUa6EFdlwDkfcU/24ZXiqzxWG7MxA+ECH/rEhkj
ebmK6wRrHO7+uEOqY8nx2IxpmZAkp23Nhov0afQpWgE7T/szq/XX7vgS30yWTJwN
uGG5Otq23ODkTsu327lb2sSzdRS5WSEZp7NZClTZtd5gPx8Tsqlsy0B5J9Y2GZS1
62jgzwT61effC3fsM8qW0vec2uA8XDde+tjSGVXUyqTqZruUSqeyTe77kiBrA3Mw
mSY4sD9l3eAUYn8ZG2L55cM99QJNJoD2OqQeeUgNVuypGEC/XXxjaJp5GLmOn/FO
pfsILEtAO11jqxeZ2/NCh3Hivip3Qs8uMsfm2z+fGbg3z66Yrc0dKSnwbNruhRvw
Dff8oeNhMu82kZp2jNJw
=VMhx
-----END PGP SIGNATURE-----

--=-Ao8NfL0RDu5IMKwt88uh--

