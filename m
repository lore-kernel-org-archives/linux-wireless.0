Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33005 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915AbbGQHNf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 03:13:35 -0400
Received: by wgmn9 with SMTP id n9so75162412wgm.0
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2015 00:13:34 -0700 (PDT)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH 0/4] refactor cmd_node recycling
Date: Fri, 17 Jul 2015 09:13:02 +0200
Message-Id: <1437117186-25243-1-git-send-email-afenkart@gmail.com> (sfid-20150717_091339_009960_F0D64CDB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following patches are trying to simplify the code paths used
to recycle processed commands

Andreas Fenkart (4):
  mwifiex: remove explicit mwifiex_complete_cmd calls
  mwifiex: remove redundant reset of cmd_wait_q status
  mwifiex: remove CMD_F_CANCELED flag
  mwifiex: simplify mwifiex_complete_cmd

 drivers/net/wireless/mwifiex/cmdevt.c    | 35 +++++++++++---------------------
 drivers/net/wireless/mwifiex/fw.h        |  1 -
 drivers/net/wireless/mwifiex/sta_ioctl.c |  4 ++--
 drivers/net/wireless/mwifiex/util.c      | 12 ++++-------
 4 files changed, 18 insertions(+), 34 deletions(-)

-- 
2.1.4

