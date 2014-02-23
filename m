Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:52468 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaBWTTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:19:44 -0500
Received: by mail-we0-f178.google.com with SMTP id q59so3907430wes.23
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:19:43 -0800 (PST)
Message-ID: <530A49C8.8060502@gmail.com> (sfid-20140223_202001_442358_609B7B59)
Date: Sun, 23 Feb 2014 21:19:36 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: pull request: iwlwifi 2014-02-23
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="lejtJKDNJxtVuKvpbDxJXsGwxP3WVsdRP"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lejtJKDNJxtVuKvpbDxJXsGwxP3WVsdRP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

One single patch for this pull request intended for 3.14.
This should fix an issue raised in iwldvm when we have lots of associatio=
n failures.
There is a bugzilla for this bug - it hasn't been validated by the user, =
but I hope it will do the trick.

I hope I fixed my line wrapping issue this time. Let me know if you are s=
till unhappy with the current format.

Thanks!
The following changes since commit 205e2210daa975d92ace485a65a31ccc4077fe=
1a:

  iwlwifi: disable TX AMPDU by default for iwldvm (2014-02-13 15:24:35 +0=
200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=
 master

for you to fetch changes up to ec6f678c74dbdb06a6a775bbb00f1d26c17c404b:

  iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails (2014-02-=
20 19:16:27 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails

 drivers/net/wireless/iwlwifi/dvm/sta.c |    1 +
 1 file changed, 1 insertion(+)


--lejtJKDNJxtVuKvpbDxJXsGwxP3WVsdRP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTCknMAAoJEC0Llv5uNjIBdRcP/AxThonp+Z6UdxNuimRUmNBp
zA+uUo+0vyL0Msrx3v1scyPxcDTpWsQ3z4QH3o7ZwIsLQnmKMLjXhrj1lvHAAv92
EHLBbDmhcnt9S8EvpubMaOhc3CwIkJDzVe3jBI8kDeFjJfg+I6cAhlHf+aMzPosG
D569ut3No8bcT+kvY13nx7ckdQz2OIZeqzGhtbDJ836+MJJvMQM0yqvHUfpFxJQ3
kaxk7fZujFAp9bPtkKzHD5dB4gctRlKLtReoSty4Okzg/3ScZB5bZQ0L8nvF7Syl
mLfLxZCcqKq27FbjryeK5Y9AUzGlZL9Cz2dv2x7t9fq94aTIB+Jb1mf4pg/pwhCA
Ch+xBdnuyNXUa4HcFK/JiLV80iADT/wSC84eOULgQPSSfYuWOSOjL80XUzuJ18KG
IbvBNUk4SULSWOsSvIGZUC9wEJ1FFhbWgPIUrtyAm5Z/UEFY433bL9ns4nbOb6A/
abRYN4RmOSQ0SSI/4sAZEccORbStSY/E/U+eyeNe3mOYHgh/R4CRS635tpoMmsM0
50tBIuYwn5yCUjmkZS3TbpbjQXYw9OrEs/EbxUzs1+f6MCGJMw0tCBeaTLMcujKq
hOlVMI+e9/ZKC6S2DONhvWCmO/oWRWnHsGXRDEnqsA8gRBXCB9P/cpqlaaceboLu
aYXFBqIACGat4ZmuIOyY
=W/Q0
-----END PGP SIGNATURE-----

--lejtJKDNJxtVuKvpbDxJXsGwxP3WVsdRP--
