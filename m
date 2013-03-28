Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab3C1PgC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 11:36:02 -0400
Message-ID: <1364484949.10397.7.camel@jlt4.sipsolutions.net> (sfid-20130328_163622_081526_EBFC9A45)
Subject: pull-request: iwlwifi-fixes 2013-03-28
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 28 Mar 2013 16:35:49 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Di2kMQwXqNh9x0w4tLxB"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Di2kMQwXqNh9x0w4tLxB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

I know you just pulled my other iwlwifi-fixes request ... but in the
meantime I debugged with Alex Romosan, you probably saw the thread, and
thus have another fix and I wanted to send it to you.

The only fix here is to the passive-no-RX firmware regulatory
enforcement driver support code to not drop auth frames in quick
succession, leading to not being able to connect to APs on passive
channels in certain circumstances.

Let me know if there's any issue. Thanks,
johannes


The following changes since commit 2d5d50ee596361566f7f84300117cba7d7672bc5=
:

  iwlwifi: dvm: don't send HCMD in restart flow (2013-03-20 12:10:57 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to b8730b403aee94db4631bfefb546a6ce8c287dc2:

  iwlwifi: dvm: fix the passive-no-RX workaround (2013-03-28 16:31:26 +0100=
)

----------------------------------------------------------------
Johannes Berg (1):
      iwlwifi: dvm: fix the passive-no-RX workaround

 drivers/net/wireless/iwlwifi/dvm/rxon.c | 18 ++++++++----------
 drivers/net/wireless/iwlwifi/dvm/tx.c   |  2 +-
 2 files changed, 9 insertions(+), 11 deletions(-)


--=-Di2kMQwXqNh9x0w4tLxB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRVGNVAAoJEDBSmw7B7bqrUNUP/3iY60GdvoFhYa7QlESuppjj
FodY7fOUYlGeCapxC/63lbePRfw5J6T2ZTFc6FDxGGnG5G6Eaj86/GcuLblwkq1u
cdhzYdRgCyJtMsJCIAXvIrwxxgm4WYFpD1CqU+8m58Y8Mn3Q1wD1gvwHISSzODtE
JoK/3zO679o4yl9LDEQ/B8ivQwCiHriNAoRbJUQqc+Ox0hcdLDFN4plUN9QLsCUk
jTI4T0ew0ij08v6Uwva9cH93jAdndy0b16OPauBsT4hyoshv0RX8Ipkj6We4rmu9
KiGfm4tpDrtXLRVTrE58Y78wn0wOz8d4CbovBwhuc8kw2OcfpA/cTFib3YR19qac
IZ6rl6sw0/69ViGNsIvihp/i0oTf/N4bOIbN4NzF5uKZ1jk8u2I5bVv7Tfn4ctKc
/U8bUx6MwnDSmG3FXVdLRG9jWKYXn8R3INpbvp46YFSePtG2ZyORbOtS80WfSb1U
UIFb3Ki9OzFEWaQH9BziHsU080U2Fcc5txIjisPig9RSO+ZE5C5lPzTKJexpzUl3
MfcvQxdq8Jxalaraw8gQBoddUbos2udzgp6CSlhQOI/fJkYUhHbIbHeGbWfriLzX
ObvUQJFgLIS1rdNhDqPkJNc7s2EkdTabIYJUZ0p79WqwcjvSUfIuOFXQOZb+gsph
lG2+O62gszyzpaqyeKyF
=5/ke
-----END PGP SIGNATURE-----

--=-Di2kMQwXqNh9x0w4tLxB--

