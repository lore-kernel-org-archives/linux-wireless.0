Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:53298 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2GSNAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 09:00:37 -0400
Subject: [PATCH v2 0/3] ath6kl: regdomain support
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 19 Jul 2012 16:00:32 +0300
Message-ID: <20120719125937.22047.91375.stgit@x201> (sfid-20120719_150041_063672_8A0CB4D4)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In v2 I splitted the wmi scan refactoring patch to make it easier to
read the changes. Also I rebased this agains latest ath6kl.git master
branch.

---

Kalle Valo (3):
      ath6kl: move ath6kl_wmi_startscan_cmd()
      ath6kl: refactor wmi scan command
      ath6kl: add support for changing contry code


 drivers/net/wireless/ath/ath6kl/Kconfig    |    9 ++
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   78 ++++++++++++------
 drivers/net/wireless/ath/ath6kl/core.h     |    3 +
 drivers/net/wireless/ath/ath6kl/wmi.c      |  124 ++++++++++++++++++----------
 drivers/net/wireless/ath/ath6kl/wmi.h      |   11 +-
 5 files changed, 151 insertions(+), 74 deletions(-)

