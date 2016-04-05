Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933079AbcDENdc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 09:33:32 -0400
Subject: =?UTF-8?Q?Re:_[PATCH]_mac80211:_fix_=22warning:_=e2=80=98target=5fm?=
 =?UTF-8?Q?etric=e2=80=99_may_be_used_uninitialized=22?=
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <5702AF3B.1070507@suse.com>
 <1459849388.18188.28.camel@sipsolutions.net>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <5703BEA7.3040406@suse.com> (sfid-20160405_153335_638744_C94C5170)
Date: Tue, 5 Apr 2016 09:33:27 -0400
MIME-Version: 1.0
In-Reply-To: <1459849388.18188.28.camel@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gFqHc6JAI9U0OXtme0faTa0Eb2ftsm4jH"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gFqHc6JAI9U0OXtme0faTa0Eb2ftsm4jH
Content-Type: multipart/mixed; boundary="f5EdvVkBmiXXDNDkb61o2phctRBv93eaB"
From: Jeff Mahoney <jeffm@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Message-ID: <5703BEA7.3040406@suse.com>
Subject: =?UTF-8?Q?Re:_[PATCH]_mac80211:_fix_=22warning:_=e2=80=98target=5fm?=
 =?UTF-8?Q?etric=e2=80=99_may_be_used_uninitialized=22?=
References: <5702AF3B.1070507@suse.com>
 <1459849388.18188.28.camel@sipsolutions.net>
In-Reply-To: <1459849388.18188.28.camel@sipsolutions.net>

--f5EdvVkBmiXXDNDkb61o2phctRBv93eaB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 4/5/16 5:43 AM, Johannes Berg wrote:
> On Mon, 2016-04-04 at 14:15 -0400, Jeff Mahoney wrote:
>> This fixes:
>>
>> net/mac80211/mesh_hwmp.c:603:26: warning: =E2=80=98target_metric=E2=80=
=99 may be used
>> uninitialized in this function
>>
>> target_metric is only consumed when reply =3D true so no bug exists
>> here,
>> but gcc doesn't notice that.  Initializing to 0 clears the warning.
>>
>=20
> What gcc version are you using? Mine doesn't seem to have a problem
> following the logic here.

gcc version 4.8.5 (SUSE Linux)

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--f5EdvVkBmiXXDNDkb61o2phctRBv93eaB--

--gFqHc6JAI9U0OXtme0faTa0Eb2ftsm4jH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXA76nAAoJEB57S2MheeWyaLMQAKJYzvaJiuRtEVLR6Falc6Hn
V5GVrLjCRzMJT6+JUc+WzybBdIkE2WcO3i1spHkAZRJSrKWsjlINCoxyHGKQaS0S
sPJVVYkPOFPGMrlRQJ/SEn0kLKzJ1pZ4mPQzalAAz3zbQUzDVoQTsiCpHRnI3k9t
WyTBkoeIywVKIBSAQeoa9T0EJaTqRxPtIbJvBTafrPc3gGO3/bkrT5XhbHO/EjP8
5c5KXki1LI5ksGRfR+wRcCVADnujdpFdoWsL/bzR5lZek+Z8vibUNxALvGN5uiCm
SXE+X33Wljte0LQW4CaupVFWCoTeSKxPYy7h2ZYxB0FmT2vGUjbSYD7rZX2oSu63
9px7hGJQUE82WXt6BsmDdZGa1mk+Gmdp1jUH3o/wfQPY7QK57NTGLx/jpaIZJOhX
Nhs4Uv1K1F6+4+JgXpBCRCo9Al93LA6kBXz5GQD5cz/oMB95wpixkc792DmGUknW
A7f5oGm5uRmVo7aFG/EE67DzJosYSJMJ88O34MNtWltTSZSsMRFqf0DVdcPQ3W2A
uZXk1IAJwH9y1lPtZ+oSjsMjU5W7BhBWaMPol5g1aqPdNfTUU9ju9A2swBXQdbXv
Gj2ZYzG6WWgewBDjym2igGwWsg3cAK7NmI5hRkNg8LHY1KZPKENnuWr9Y1F+Iptu
W25ueCu/cVUy1OrBjRMc
=WMUT
-----END PGP SIGNATURE-----

--gFqHc6JAI9U0OXtme0faTa0Eb2ftsm4jH--
