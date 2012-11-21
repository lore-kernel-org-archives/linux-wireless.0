Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2KUOV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 09:21:29 -0500
Message-ID: <1353507714.10444.25.camel@jlt4.sipsolutions.net> (sfid-20121121_152133_265825_B364F946)
Subject: pull-request: iwlwifi 2012-11-21
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 21 Nov 2012 15:21:54 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-7zQ3CijTPeOpKPCIzZKK"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7zQ3CijTPeOpKPCIzZKK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I'd hoped that my previous pull request was the last ... but then
Emmanuel was working on ack rates and found another bug that's been
there for a while.

Please pull (per below) to get a fix for the CCK basic rate calculation
in iwlwifi.

If you don't want to put this into 3.7 any more, I think that's ok, this
code has been broken forever without causing much trouble (it was broken
even before the change that caused the current bug.)

johannes


The following changes since commit e1b69fdf33f63cfa600b992172d7376f9d9ef2e9=
:

  iwlwifi: don't WARN when a non empty queue is disabled (2012-11-18 11:51:=
09 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to 5edd0b946a0afeb1d0364a3654328b046fb818a2:

  iwlwifi: fix the basic CCK rates calculation (2012-11-21 11:31:21 +0100)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: fix the basic CCK rates calculation

 drivers/net/wireless/iwlwifi/dvm/rxon.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


--=-7zQ3CijTPeOpKPCIzZKK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQrOOCAAoJEDBSmw7B7bqrGpYP+wWnyu2PWuTWsOACEABAjy+T
iM+MbxttphMPE42T26CpusTtrzWHxMMfDk1dPnFgEVmRkcuapHF2QNCNlNgQtQ65
87WOQ2eCKOH03CAWFaWo7jFd+0Jqb69L3Z4LMnpkk80sLtbhkPxtWOCBqlfwMQdu
10cXA5lGxZHoQ1KQw9b+oYrVAoY3NT5CoeoATpcTr6RkLs6Wsgnq/AMhS80Bgx/W
vPXhufznJ1dqEu9RJTD/Egt+sBO3eL98ZX1L0Lf6YBvYUHZeDgfbSK1PSY9GJtPh
rQGO+4CSyVclvZ+MsBB1lOabhqlYEJfbGHkMhoH784MZcfIM8BekncKRh8ns2yt3
EvYhHootxJN/uHn1LaeGCjWCzII+ieSigreuLEOBDbxDPhBE4OMXK3oUNqCx8Fz8
+M5qt2zUs+xGDk/U5UTk/YrEDdaUWqtbDiwe96uEHzbGTiPlsVMUvdU/9Vy47k7S
UjOj24eNMPXQlS91uyTqNsa/w3NGFIb/t49Zwf1ESQ+B7g0IKockHFr5OIqlfgb0
WrFtDnyUiRmZsfI0u7GeMGgMH0lu8pqCDaCx5P73AuTKWu1YvrQve/4Q3BqAXg6Z
eVcoxl3jz3znG1wYMPWSWMIYZIVm42hb5KnuG9cetheuBxg35WcIpYvq2Wx86T6Y
9flbyDr8+3x3EK9l27QY
=f5Xz
-----END PGP SIGNATURE-----

--=-7zQ3CijTPeOpKPCIzZKK--

