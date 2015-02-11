Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:55176 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbbBKSoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2015 13:44:03 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: David Miller <davem@davemloft.net>
CC: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: pull-request: wireless-drivers 2015-02-11
Date: Wed, 11 Feb 2015 20:43:53 +0200
Message-ID: <87iof8l252.fsf@kamboji.qca.qualcomm.com> (sfid-20150211_194427_434276_6B3A2524)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

here's one rtlwifi fix for 3.20. We have had two reports of this issue
already, so it would be good to get this to -rc1 or -rc2.

I rebased wireless-drivers on top of net-next, so this patch applies to
net-next. I hope that's ok.

Kalle

The following changes since commit b0f9ca53cbb103e9240a29a974e0b6085e58f9f7:

  ipv4: Namespecify TCP PMTU mechanism (2015-02-09 18:45:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2015-02-11

for you to fetch changes up to aeb2d2a4c0ae1739a6e1782bd8c1c96aee8db4e1:

  rtlwifi: Remove logging statement that is no longer needed (2015-02-10 16:09:11 +0200)

----------------------------------------------------------------
rtlwifi:

* remove superfluous warning message which is not needed anymore

----------------------------------------------------------------
Larry Finger (1):
      rtlwifi: Remove logging statement that is no longer needed

 drivers/net/wireless/rtlwifi/pci.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)
