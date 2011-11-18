Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab1KRIU4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:20:56 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8KuSC022516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:20:56 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 03/77] iwlegacy: rename priv to il
Date: Fri, 18 Nov 2011 09:21:25 +0100
Message-Id: <1321604559-10707-3-git-send-email-sgruszka@redhat.com> (sfid-20111118_092059_866828_8E427612)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make code shorter.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c |   90 +-
 drivers/net/wireless/iwlegacy/iwl-3945-led.c     |    4 +-
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c      |  156 +-
 drivers/net/wireless/iwlegacy/iwl-3945.c         |  786 +++++-----
 drivers/net/wireless/iwlegacy/iwl-3945.h         |   78 +-
 drivers/net/wireless/iwlegacy/iwl-4965-calib.c   |  220 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-calib.h   |   10 +-
 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c |   92 +-
 drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c  |   34 +-
 drivers/net/wireless/iwlegacy/iwl-4965-led.c     |   12 +-
 drivers/net/wireless/iwlegacy/iwl-4965-led.h     |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c     |  378 +++---
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c      |  372 +++---
 drivers/net/wireless/iwlegacy/iwl-4965-rx.c      |   74 +-
 drivers/net/wireless/iwlegacy/iwl-4965-sta.c     |  390 +++---
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c      |  472 +++---
 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c   |   54 +-
 drivers/net/wireless/iwlegacy/iwl-4965.c         |  680 ++++----
 drivers/net/wireless/iwlegacy/iwl-4965.h         |  120 +-
 drivers/net/wireless/iwlegacy/iwl-core.c         | 1016 ++++++------
 drivers/net/wireless/iwlegacy/iwl-core.h         |  264 ++--
 drivers/net/wireless/iwlegacy/iwl-debug.h        |   16 +-
 drivers/net/wireless/iwlegacy/iwl-debugfs.c      |  338 ++--
 drivers/net/wireless/iwlegacy/iwl-dev.h          |   62 +-
 drivers/net/wireless/iwlegacy/iwl-eeprom.c       |  158 +-
 drivers/net/wireless/iwlegacy/iwl-eeprom.h       |   18 +-
 drivers/net/wireless/iwlegacy/iwl-hcmd.c         |   72 +-
 drivers/net/wireless/iwlegacy/iwl-helpers.h      |   50 +-
 drivers/net/wireless/iwlegacy/iwl-io.h           |  324 ++--
 drivers/net/wireless/iwlegacy/iwl-led.c          |   72 +-
 drivers/net/wireless/iwlegacy/iwl-led.h          |    4 +-
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h    |   12 +-
 drivers/net/wireless/iwlegacy/iwl-power.c        |   76 +-
 drivers/net/wireless/iwlegacy/iwl-power.h        |    6 +-
 drivers/net/wireless/iwlegacy/iwl-rx.c           |   42 +-
 drivers/net/wireless/iwlegacy/iwl-scan.c         |  272 ++--
 drivers/net/wireless/iwlegacy/iwl-sta.c          |  388 +++---
 drivers/net/wireless/iwlegacy/iwl-sta.h          |   38 +-
 drivers/net/wireless/iwlegacy/iwl-tx.c           |  168 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c     | 1868 +++++++++++-----------
 drivers/net/wireless/iwlegacy/iwl4965-base.c     | 1750 ++++++++++----------
 41 files changed, 5518 insertions(+), 5520 deletions(-)

893K patch can be downloaded from:
http://people.redhat.com/sgruszka/iwlegacy-2011-11-16/0003-iwlegacy-rename-priv-to-il.patch
