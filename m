Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24702 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab1HOIBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 04:01:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/4] ath6kl: pending patches from 2011-08-14
Date: Mon, 15 Aug 2011 01:03:59 -0700
Message-ID: <1313395443-5392-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110815_100153_113346_25435778)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are few patches which were sent me privately before I created ath6kl
tree. I have applied them to ath6kl tree now.

In the future we will send all patches to the linux-wireless mailing
list first.

Kalle Valo (1):
  ath6kl: fix indentation in htc_issued_send()

Kevin Fang (1):
  ath6kl: Add beginning of AR6004 initialisation support

Raja Mani (2):
  ath6kl: Avoid finding bss presence in cfg80211 scan list
  ath6kl: Check sme state before delivering disconnect event to
    cfg80211

 drivers/net/wireless/ath/ath6kl/bmi.h      |    4 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   23 +-----
 drivers/net/wireless/ath/ath6kl/core.h     |    7 ++
 drivers/net/wireless/ath/ath6kl/htc.c      |    2 +-
 drivers/net/wireless/ath/ath6kl/init.c     |  136 ++++++++++++++++++++--------
 drivers/net/wireless/ath/ath6kl/main.c     |   20 ++++-
 drivers/net/wireless/ath/ath6kl/target.h   |   16 +++-
 7 files changed, 142 insertions(+), 66 deletions(-)

