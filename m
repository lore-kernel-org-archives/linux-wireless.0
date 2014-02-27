Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53669 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaB0HBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 02:01:17 -0500
Received: by mail-wi0-f181.google.com with SMTP id hi5so3078465wib.14
        for <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 23:01:16 -0800 (PST)
Message-ID: <530EE2B9.4020708@gmail.com> (sfid-20140227_080121_239548_F1249F2F)
Date: Thu, 27 Feb 2014 09:01:13 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: Re: pull request: iwlwifi 2014-02-27
References: <530EE0EA.5030105@gmail.com>
In-Reply-To: <530EE0EA.5030105@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="6jvoiMothieAX887XTHFBEmrVA4H6skxX"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6jvoiMothieAX887XTHFBEmrVA4H6skxX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable



On 02/27/2014 08:53 AM, Emmanuel Grumbach wrote:
> Hi John,
>=20
> I have two fixes for 3.14.
> Johannes fixes a long standing bug in the AMPDU status reporting.
> Max fixes the listen time which was way too long and causes trouble to =
several APs.
>=20
> Please pull - thanks
>=20
>   emmanuel
>=20
> The following changes since commit ec6f678c74dbdb06a6a775bbb00f1d26c17c=
404b:
>=20
>   iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails (2014-0=
2-20 19:16:27 +0200)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.g=
it master
>=20
> for you to fetch changes up to d8105a24fce48b7b016e868923000871f4196e63=
:
>=20

Made a minor change in the commit message of one of the patches - new HEA=
D:082e29cb547474aa19c028d75d81bc5d873774f4.




--6jvoiMothieAX887XTHFBEmrVA4H6skxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTDuK5AAoJEC0Llv5uNjIBODcP/0LIk92cayTWOo2csHMaT0sY
YVOwk2oGb/cuIufiLIuo3PzRH++uRXN3rt4mJn/0fJNG5XaLWjiCWRLLew8eIV3K
1y9D4UFvHeNpXOkpZmIDGQy03bb8uu+D9l1AhVoaSZAr8uwFSV/h4bL1wayTuZE8
wNZ+AS6CH2VhZ6irnIXFzYJyOytyltrrgAqVlUSjtXEIg8fYvmybkyE9CpQZzqlH
OezXmPDfhf25Ubah75XM73Qx+negbp/mAXChZjXezAz0GlnEViAqOgblFE0r0CVW
uFSugrkE6Glx+2RoXiQMr2eHmsheZs8e6wrccoZJ+zk9gWvuDGAV0iCw7oBuLU6e
p38wQ5vvlLpxmOK8gj/db+dOL51QR6uGe7cCmP16eL+7ZFpGKKKk8JD0hElJtNsE
bcnXJA/Cpk7xhawIQVoKA2BIK1RP5ScpLDJ03hh+mW0acI4IW35kJxdtOLRBVsSL
jMD+ZSTIPVuOXQClbMPVA6LSdDH0af5JidgeR5r/ZEhjN/MrekF7mMe6c8eXrYle
xjPjrq+nFJngWs1tBXvm5mX6yJ3wcQbtXqLL1eGGTlH4iapwvEToYnm9hPl/P49y
16qHZdXuQ9rWE3ZR8JlEq8FuWijVPih+CDHsDxa8W7loghwFRpe/jMiuaI5Epkix
9n7v9ToMG8gei04WZ0Jf
=iXs7
-----END PGP SIGNATURE-----

--6jvoiMothieAX887XTHFBEmrVA4H6skxX--
