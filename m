Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:38311 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab3LaQ7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 11:59:30 -0500
Received: by mail-ee0-f42.google.com with SMTP id e53so5569039eek.15
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 08:59:29 -0800 (PST)
Message-ID: <52C2F7EA.3050600@gmail.com> (sfid-20131231_175935_370853_EAB7FE0F)
Date: Tue, 31 Dec 2013 18:59:22 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: pull request: iwlwifi 2013 12 31
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="I8OknrOiF7Rw0a6A60OLk8Q6bj5mKOebT"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--I8OknrOiF7Rw0a6A60OLk8Q6bj5mKOebT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This is a pull request intended for 3.13.
It only includes new device IDs so it's not vital. If you have a pull
request to net.git anyway, I'd happy to have this in. If not, I'll CC
stable later.

Thanks!

The following changes since commit 3c5da7eefce5835acfc73ebd0a4f961cdae4ae=
67:

  iwlwifi: mvm: use a cast to calculate the last seqno from the next one
(2013-11-25 23:00:21 +0200)

are available in the git repository at:


git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
for=3Djohn

for you to fetch changes up to efc5520c4224479967b7381775a63fb48283b082:

  iwlwifi: add new devices for 7265 series (2013-12-31 17:32:20 +0200)

----------------------------------------------------------------
Oren Givon (1):
      iwlwifi: add new devices for 7265 series

 drivers/net/wireless/iwlwifi/pcie/drv.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


--I8OknrOiF7Rw0a6A60OLk8Q6bj5mKOebT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSwvfsAAoJEC0Llv5uNjIBxF0P/AsoNtU0QtgApEwhk8pMmCvY
PRZ6WeuW0OvbIzXzsKlXeiUg4Rzz9639vcy8V8LKF9TYgTVKzO1uoHQZevA3VaST
t5BtMHFpiNZ3p+5yCh9oPSNWNtFygHMjJ00+r9GGOCAabquBjSisvJIFUxxwFgfK
5GkzIajx/te0RDz0y+QS4n8h8ZnW0N/o4yDyBASxgxextecw6XmCSSS1ghLW4pgr
IfIE8KptDUMcelIItXa0En0+34SZlcnzJOOPg73EcxXEeVo3aut1vPpqIiAS3+bo
THFaUHU6wr3gWvC981a2QORueg1QJmUGjmm670KjGsq4UJC71vCIepAp6wzdXawC
WHcMjycVEwX0P5sLSXis/cswNo0cuuv5C1Nn45vzAfS+4119/U5ICM1c5SM5ynhz
ePHn7J7AXJvQ/ejy3AIhoeNpl67A+WqyBmqpTX4RsAppEvgIzHAPHlXzHBxHFfSJ
eVf01LSoyc6VhTMhfo2x+WKldyjA/aliiHoiy6iOE+lkQLmGRSBb3kHcGfEGGTaO
6QupY4hhiw5X+e/lHGTGZ/Id+C5KlIScoRh+EYNuJUN3oxXjDLYUQm9IOF1aPC4a
lYgva5OgTo3xsDuT6m0QiieoZRPx+qrIbr+XBKhMqW+Yja0PFIwaGxStvSEYL75S
D9fiW1SK8VieJCwkTqsr
=sC9u
-----END PGP SIGNATURE-----

--I8OknrOiF7Rw0a6A60OLk8Q6bj5mKOebT--
