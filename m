Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:61258 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaFZOPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2014 10:15:11 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Pull request: ath-current 20140626
Date: Thu, 26 Jun 2014 17:15:02 +0300
Message-ID: <878uojzrix.fsf@kamboji.qca.qualcomm.com> (sfid-20140626_161517_733841_46A2B529)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a pull request with two ath10k patches I would like to get into
3.16. Both of the changes are small and pretty safe. Change log:

Bartosz fixed an issue where we were not able to create 8 vdevs when
using DFS. Michal removed a false warning which was just confusing
people.

The following changes since commit a715c7ddd65a1a3b2839b8ebd759bb2d361f7675:

  wil6210: improve debug for WMI receive (2014-05-30 13:49:34 -0400)

are available in the git repository at:

  git://github.com/kvalo/ath.git ath-current

for you to fetch changes up to dfa413de1e4388818f7dcdce0a90d6212e74895b:

  ath10k: fix 8th virtual AP interface with DFS (2014-06-02 21:44:53 +0300)

----------------------------------------------------------------
Bartosz Markowski (1):
      ath10k: fix 8th virtual AP interface with DFS

Michal Kazior (1):
      ath10k: remove unnecessary htt rx corruption check

 drivers/net/wireless/ath/ath10k/core.c   |    6 +++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c |   18 ------------------
 2 files changed, 5 insertions(+), 19 deletions(-)
