Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60190 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759190Ab0I0R7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 13:59:07 -0400
Received: by bwz11 with SMTP id 11so3540089bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 10:59:05 -0700 (PDT)
Message-Id: <cover.1285544496.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 27 Sep 2010 01:41:36 +0200
Subject: [PATCH 0/6] carl9170: updates
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few more random changes.
Note: I do have some problems with -rc5, so this series
might need some external testing.

Christian Lamparter (6):
  carl9170: remove non-standard ba session teardown
  carl9170: angle brackets for wiki link
  carl9170: remove lost-frame workaround
  carl9170: fix tx_ampdu_upload counter
  carl9170: fix WARN_ON triggered by Broadcom HT STAs
  carl9170: revamp carl9170_tx_prepare

 drivers/net/wireless/ath/carl9170/Kconfig    |    2 +-
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 -
 drivers/net/wireless/ath/carl9170/debug.c    |    4 -
 drivers/net/wireless/ath/carl9170/main.c     |   20 ++-
 drivers/net/wireless/ath/carl9170/tx.c       |  192 ++++++++++---------------
 5 files changed, 93 insertions(+), 126 deletions(-)

