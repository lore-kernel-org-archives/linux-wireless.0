Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:53856 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaEORDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:03:51 -0400
Received: by mail-we0-f181.google.com with SMTP id w61so1356004wes.40
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:03:50 -0700 (PDT)
Message-ID: <5374F373.6040902@gmail.com> (sfid-20140515_190356_035821_030EF246)
Date: Thu, 15 May 2014 20:03:47 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: pull  request iwlwifi-next 2014-05-15
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="lCDjVirJNQbMidq6K2AxfvfcdDkA0xLbi"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lCDjVirJNQbMidq6K2AxfvfcdDkA0xLbi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This is *not* the last pull request for 3.16 :)
I have just enough content for a pull request and prefer to send it now, =
and have another (smaller) one later (not too late).
Again, I had to merge iwlwifi-fixes.git to avoid a merge conflict.

Avri continues to work on the power code and Eran is improving the NVM ha=
ndling as a preparations for new devices on which he works with Liad. Luc=
a cleans up a bit the code while working on CSA. I have the regular BT Co=
ex stuff and a small lockdep fix. Johannes has his regular amount of clea=
n ups and improvements, the main one is the ability to leave 2 chains ope=
n to improve diversity and hence the throughput in high attenuation scena=
rios.

Please pull, thanks.

The following changes since commit 1c4abec0baf25ffb92a28cc99d4231feeaa4d3=
f3:

  iwlwifi: mvm: fix setting channel in monitor mode (2014-05-11 13:10:08 =
+0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
master

for you to fetch changes up to af7c603eb476216f1c27d82b802f0ce879c54ab3:

  iwlwifi: fix LED support Kconfig dependencies (2014-05-15 19:56:18 +030=
0)

----------------------------------------------------------------
Avri Altman (2):
      iwlwifi: mvm: Add power management support for P2P DCM
      iwlwifi: mvm: Disable uAPSD for a DCM client

David Spinadel (2):
      iwlwifi: mvm: notify sched scan complete from stop routine
      iwlwifi: mvm: stop sched scan before association

Eliad Peller (1):
      iwlwifi: mvm: set SKIP_OVER_DTIM flag only if needed

Emmanuel Grumbach (7):
      iwlwifi: dvm: don't use _ni mac80211's callbacks
      iwlwifi: pcie: try to get ownership several times
      Merge remote-tracking branch 'iwlwifi-fixes/master' into HEAD
      iwlwifi: remove CMD_SYNC
      iwlwifi: pcie: disable BHs in iwl_pcie_txq_check_wrptrs
      iwlwifi: mvm: BT Coex - fix boost register / LUT values
      iwlwifi: mvm: BT Coex - send channel inhibition before association

Eran Harary (4):
      iwlwifi: 8000: add default NVM file name in family 8000
      iwlwifi: mvm: add channel 14 to the low band list
      iwlwifi: mvm: revisit the NVM handling code
      iwlwifi: allow dynamic configuration of internal memory

Johannes Berg (5):
      iwlwifi: add missing trailing newlines to debug messages
      iwlwifi: cause build error on missing newline
      iwlwifi: remove spurious newline in Kconfig
      iwlwifi: mvm: enable RX chain diversity if needed
      iwlwifi: fix LED support Kconfig dependencies

Liad Kaufman (2):
      iwlwifi: use dev_printk instead of dev_dbg for debug logs
      iwlwifi: update nmi register

Luciano Coelho (1):
      iwlwifi: mvm: combine p2p and station mac context functions

Matt Chen (1):
      iwlwifi: mvm: add uapsd_disable module parameter


--lCDjVirJNQbMidq6K2AxfvfcdDkA0xLbi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTdPN1AAoJEC0Llv5uNjIBjuAP/iqwUzwOAdDVUv33GescsltH
5orhE69keXqCsFKPYb+zQWgTZCf+vJoODKRhUaBJ+3OnfXsUm3iEJak6ICqPNGQe
O7Xv5yqIyPQDFEsAuexh9iEbWng+n1/mxdO/CfhkPtmeTdkuy1cMCJNPdHxvXJaS
+q3/SabeDLkHWdGhgzUNRM0Q9VFj9b0hSGjDuVIvrgP8j+ZrGh3l4Nm9LDw5muDV
N2zLEL5v+saKN5csTIOK8wq11DrigmWeTyMTSFx7LysWZLMczkmr23SbitJQTbZs
WAgszcpZqsjP+HZU96OHnCOlXmtHYgUXoqonUD5lTnZzmjzmQXw7xmZ6guLMzC3P
7SqydnaOtW7cLxVzit/gzBXL2aHLvdJeV07h9hw3i9NV4VWTPsRCsbPEJ1Y1DC57
OOOoLZhDCatp/whVWfJHeXKmYCWLSZ+M2/jVdJe0oWzGq4o0YqXnfFT4FLs8iPVV
dHAeE1ljZKQpkL4HI1IST19ePC+evhg3t0APUCdfL19uYlCJsOVUQOF4wJRNdSzl
fdL1KXkbPUCAxDz6XDewsxbckuPPj34wioecQjxl22x5/McV+MbORbbp2w9R0kHn
QlYzs3vSmPNocqmlI30+FfJNN6cEHaErWVgWJ9AGkBqMB7NkJXmKj85d+N11Y8Oy
mS5EL34LZSTuY32aT97I
=FLWo
-----END PGP SIGNATURE-----

--lCDjVirJNQbMidq6K2AxfvfcdDkA0xLbi--
