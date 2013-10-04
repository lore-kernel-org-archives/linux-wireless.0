Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42910 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab3JDGN0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 02:13:26 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: minor fixes
Date: Fri, 4 Oct 2013 08:13:18 +0200
Message-ID: <1380867200-19714-1-git-send-email-michal.kazior@tieto.com> (sfid-20131004_081329_036398_4D553456)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The patchset fixes a compilation warning and a
memory leak in FW loading code.

Michal Kazior (2):
  ath10k: fix printf format string
  ath10k: fix possible memory leak in new FW loading

 drivers/net/wireless/ath/ath10k/core.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

-- 
1.7.9.5

