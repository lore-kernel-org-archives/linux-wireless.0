Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36774 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaE2XUr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 19:20:47 -0400
Date: Fri, 30 May 2014 01:20:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.16] NFC update
Message-ID: <20140529232016.GA19965@zurbaran> (sfid-20140530_012050_802020_95203CA7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Hopefully not too late for a last NFC pull request for 3.16.
We have:

- Felica (Type3) tags support for trf7970a
- Type 4b tags support for port100
- st21nfca DTS typo fix
- A few sparse warning fixes

Thanks in advance for pulling them in.

The following changes since commit ef1b075c15d55c71200c63450756a9bb51ce2a60:

  mwifiex: use 'const' qualifier for 2nd arg of mwifiex_tdls_add_ht_oper (2014-05-22 14:21:12 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git nfc-next-3.16-2

for you to fetch changes up to 6857bb96271cd40ffb38825d43897d716310e3db:

  NFC: trf7970a: Add support for Felica Type 3 tags (2014-05-26 01:28:28 +0200)

----------------------------------------------------------------
Christophe Ricard (1):
      NFC: dts: st21nfca_i2c: Correct minor typo in documentation

Fengguang Wu (2):
      NFC: digital: digital_in_send_attrib_req() can be static
      NFC: nfc_sock_link() can be static

Mark A. Greer (1):
      NFC: trf7970a: Add support for Felica Type 3 tags

Thierry Escande (3):
      NFC: port100: Add support for type 4B tag
      NFC: digital: Return proper error code when sending ATR_REQ
      NFC: digital: Randomize poll cycles

 .../devicetree/bindings/net/nfc/st21nfca.txt       |  2 +-
 drivers/nfc/port100.c                              | 36 +++++++++++++++++++++-
 drivers/nfc/trf7970a.c                             | 13 +++++++-
 net/nfc/digital_core.c                             |  6 ++--
 net/nfc/digital_dep.c                              |  5 ++-
 net/nfc/digital_technology.c                       |  2 +-
 net/nfc/rawsock.c                                  |  4 +--
 7 files changed, 57 insertions(+), 11 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
