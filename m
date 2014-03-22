Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62565 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaCVR6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2014 13:58:35 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so2903794eei.33
        for <linux-wireless@vger.kernel.org>; Sat, 22 Mar 2014 10:58:34 -0700 (PDT)
Message-ID: <532DCF45.70509@gmail.com> (sfid-20140322_185902_666505_33989539)
Date: Sat, 22 Mar 2014 19:58:29 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: ben@decadent.org.uk
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com, dwmw2@infradead.org
Subject: pull request: firmware for Intel wireless 7265
References: <532DCDB6.4080409@gmail.com>
In-Reply-To: <532DCDB6.4080409@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ANpPSEP11InqCXirJ69XbqHUGAfhUwxJf"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ANpPSEP11InqCXirJ69XbqHUGAfhUwxJf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Ben,

This adds the firmware for a new Intel Wireless device: 7265.

Thanks!

The following changes since commit dec41bce44e0dff6a2c3358a958fadf22bf588=
58:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/=
egrumbach/linux-firmware (2014-03-16 18:12:54 +0000)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware.=
git master

for you to fetch changes up to 7c9322ffc746f897db884aacbcf9c115fc840209:

  iwlwifi: add firmware for 7265 (2014-03-22 19:45:06 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: add firmware for 7265

 WHENCE               |   3 +++
 iwlwifi-7265-8.ucode | Bin 0 -> 690452 bytes
 2 files changed, 3 insertions(+)
 create mode 100644 iwlwifi-7265-8.ucode


--ANpPSEP11InqCXirJ69XbqHUGAfhUwxJf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTLc9HAAoJEC0Llv5uNjIBPpgP/1eEkzpBnhx43Q1MvQtSiC82
ww6jDJZ8DAyyuQQLXspWp82tDFGRLxeBOUHDNapT5AhQULvviOcrpIZLtHvaZmkb
HpgznpTdeWVPdif3Pt4KOGTcYxQqbmW2ygnH+Mk987O6f6KNSGAV5Mjil+NJ2uzk
Xcjo1ZiCtJNrfyeoyZ5xbSB4dbogM1dwXfSMInAeYCSLMCO6ke1Ouc6FRwBAH/P4
cu4VKlQb+ymMf4PgxRVG16IDewHHCQdeDj/LXWjfoS+oXOezNNDuZixpXYxGs9xp
BrTDHJRa+AKbMrx1hgz0fk46EVOt4+qeNw7S/1Iwn48LwZ2doPQQE/0+iYIE3hjF
dVxYgpfQRKEIyN6t50aVAS5ZrcVVB/R5bW413NYM9jKDCq5Imc0jhX5P5rWUQrzH
48TIXwNewUQkZ23p0Yk58cYi+Ta3RoUxdO5+fVgFi30kOld3ysqLnSEkzCraSHoz
3zyai+bNJBFAwqSIQ3AdHVr4DiOZKnjoSLMIKpdyJ5jHOaTtFS9PM5hQ76W/R0B6
FY4oFQE++QLoXOst8j/sG85u2ys8xatOMIfo7GeChAlFPgOEFfNN1I77dWC2H+xc
MTeghI1HroadOyG/nQdnNcGdTE1+1TVYKOcJgBuFlQa5ATg/LSPuuN9yeJL2pt5m
d346KGyiqH30rKQCnNa7
=oXlx
-----END PGP SIGNATURE-----

--ANpPSEP11InqCXirJ69XbqHUGAfhUwxJf--
