Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934174Ab3CZJbk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 05:31:40 -0400
Message-ID: <1364290290.8319.6.camel@jlt4.sipsolutions.net> (sfid-20130326_103144_417469_316EFE54)
Subject: pull-request: iwlwifi-fixes 2013-03-26
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Mar 2013 10:31:30 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-UtF/9vK+ncj1htfhBGzh"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UtF/9vK+ncj1htfhBGzh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

It looks like I forgot to send this pull-request earlier ...

I have three little fixes to the driver from Emmanuel. One addresses a
small bug Ben Hutchings found during the stable review process and two
address some warnings in the driver when RF-Kill is asserted.

Please pull.

Thanks,
johannes


The following changes since commit 2470b36e84a2e680d7a7e3809cbceae5bfae3606=
:

  iwlwifi: mvm: don't warn on normal BAR sending (2013-03-04 13:39:02 +0100=
)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to 2d5d50ee596361566f7f84300117cba7d7672bc5:

  iwlwifi: dvm: don't send HCMD in restart flow (2013-03-20 12:10:57 +0100)

----------------------------------------------------------------
Emmanuel Grumbach (3):
      iwlwifi: fix length check in multi-TB HCMD
      iwlwifi: set rfkill in internal state of the transport
      iwlwifi: dvm: don't send HCMD in restart flow

 drivers/net/wireless/iwlwifi/dvm/lib.c    |  9 +++++++++
 drivers/net/wireless/iwlwifi/dvm/ucode.c  |  4 ++--
 drivers/net/wireless/iwlwifi/pcie/trans.c | 13 +++++++++++++
 drivers/net/wireless/iwlwifi/pcie/tx.c    |  2 +-
 4 files changed, 25 insertions(+), 3 deletions(-)


--=-UtF/9vK+ncj1htfhBGzh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRUWryAAoJEDBSmw7B7bqrZ9EQAI5vjrv5k+fCB4ufYyoLF/dv
allg1SrvB/1q9Qbrck0oLD+0UC0XNlO1laRvmPXbcLgiEFHqzxY+YRrCdxzq4dtm
ndMZcgk/n/NU5K6CLnuu1RYtmTabmJNv67ZNEInVO1zna94pFogbjz8/itDg9W8u
Vzm/W3FWFRnZ1Ohg2k6L22t7z0jItkZ+rw8ulNJ/W2lpFlUWaJp2rALB5STL5QdB
4AvOFrOlCvIWaOqnkKllt71Pn1URHpZ2M2hKh3Y1frqPXU+yx7CV/63CwXUoMuqv
VD7QeiuiFI37/1p0g+82SuPCqNCcfWkewAhm0tqSXWc4+/zUTw4iGA1HcyrRancU
XIh4uQ5UweyAdcBGAi9BO9/aSrKxsEHqp4JJxSTGBY+YMyslVGllRtZXrh7CR1f3
/HdgjxxeAHhjxtkqphTgDWgVq1d546+u1s9EkdET6bYVz0dZeAPXz6wn2TGibrFp
H9lkapqJ1tY7NMJHxttzcxvzw/z/8fFHYNyzig6RnynyHcBACCtFOK+fl4IzkKC0
IF+kciz4qKYq3DnHCFycUPUsK934Os4RXcnC78109oS/Xf9PKB1iVgIYiXvT+0XF
hKASVSVUymVXvS8gbKxi0FlpyOPCOKJXNLZxVoGpg9Jb+x7WSdqXQoqLv17zxuOd
dsxkRgcns0Z4/ltBQtq+
=i6oZ
-----END PGP SIGNATURE-----

--=-UtF/9vK+ncj1htfhBGzh--

