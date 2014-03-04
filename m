Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:59794 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaCDRfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 12:35:54 -0500
Received: by mail-wg0-f45.google.com with SMTP id m15so5474493wgh.16
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 09:35:53 -0800 (PST)
Message-ID: <53160EF4.8090005@gmail.com> (sfid-20140304_183557_689870_D611E15C)
Date: Tue, 04 Mar 2014 19:35:48 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: pull request: iwlwifi 2014-03-04
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="a3uEt7g4nLU4uI7O2XrAcMMNGuFXlkagJ"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--a3uEt7g4nLU4uI7O2XrAcMMNGuFXlkagJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

One more fix and an update for device IDs.
There is a bugzilla reported for the fix which is mentioned in the commit=
 message.

Please pull.

	 emmanuel

The following changes since commit 143582c6847cb285b361804c613127c25de60c=
a4:

  iwlwifi: fix TX status for aggregated packets (2014-02-27 10:28:03 +020=
0)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=
 for-john

for you to fetch changes up to acfcd9ed588465e48efe5ceb67177096d51c95a9:

  iwlwifi: fix and add 7265 series HW IDs (2014-03-04 19:30:06 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: mvm: don't WARN when statistics are handled late

Oren Givon (1):
      iwlwifi: fix and add 7265 series HW IDs

 drivers/net/wireless/iwlwifi/mvm/bt-coex.c | 7 +++++--
 drivers/net/wireless/iwlwifi/pcie/drv.c    | 5 ++---
 2 files changed, 7 insertions(+), 5 deletions(-)


--a3uEt7g4nLU4uI7O2XrAcMMNGuFXlkagJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFg73AAoJEC0Llv5uNjIBt44P/RgqxfeARyzN0iL/LDjbYcEz
DKhkAoFpTiKsI/fLE+J5B/5b10whiJtqOmREjozGcrqz4HnjvCfUOk+izhBIon0A
iLiMUUSK6I/QWskfQHp2ntBuaqkwWlVidfHid0wBZ247HgrW5X0mPbG/Lfpq+ASx
WgMH7GpzPY8srRxkPXbkuIFBQ2hVjry3RUTojL3QpNvsSq/+hGRlPmfE5/XTCDBw
0CepRQUn8Yjruy3txPCaoeX9Nhf7UoELRuWbbP2mMw26B//KnecRjVO6y2HqS9hN
MWKnRNXRymw0pHCMe4182tGw5yysKf2fgxN3vtQd5vU9ZEuEPm5XcQ9FafqAAu9q
QJY/Uv66dKiCof5YI2vS9RQW2HlAiF0Jza/571nxSqavnh04eIhaGMFUDU7sm6rU
+hUqMHGYEuV8JRDOsR8R/+nmHJGlMI1S0jxBDjgS4Dbdr1taKG6kkLvw/2QPaokL
zWp24MeHSKnGwVl97YIM+2XpVZZA/tJlgizoy4gVHEUcZQXBUdVObzG4rKcyeC7X
nR3Vj4M/3TPRTHivpaboX011ZM1ZBbIhnCkgz2vkcahrN4G3Iil3AloxYARuIxRS
J1TolDMWePXeilr3i36SHTymL3kL/4B5WMuun4o2JGb57yp6QEg2knBzh27ze/4m
yz8gzfmZwlPfGzQ6qYki
=/hcl
-----END PGP SIGNATURE-----

--a3uEt7g4nLU4uI7O2XrAcMMNGuFXlkagJ--
