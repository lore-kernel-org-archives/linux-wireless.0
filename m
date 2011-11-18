Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210Ab1KRIVs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:48 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8Lmfq032295
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:48 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 28/77] iwlegacy: rename base 4965 and 3945 file names
Date: Fri, 18 Nov 2011 09:21:50 +0100
Message-Id: <1321604559-10707-28-git-send-email-sgruszka@redhat.com> (sfid-20111118_092158_938929_87D8BF1A)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c     | 4007 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlegacy/3945.c         | 2740 ++++++++++++++++++
 drivers/net/wireless/iwlegacy/4965-mac.c     | 3245 +++++++++++++++++++++
 drivers/net/wireless/iwlegacy/4965.c         | 2183 ++++++++++++++
 drivers/net/wireless/iwlegacy/Makefile       |    4 +-
 drivers/net/wireless/iwlegacy/iwl-3945.c     | 2740 ------------------
 drivers/net/wireless/iwlegacy/iwl-4965.c     | 2183 --------------
 drivers/net/wireless/iwlegacy/iwl3945-base.c | 4007 --------------------------
 drivers/net/wireless/iwlegacy/iwl4965-base.c | 3245 ---------------------
 9 files changed, 12177 insertions(+), 12177 deletions(-)
 create mode 100644 drivers/net/wireless/iwlegacy/3945-mac.c
 create mode 100644 drivers/net/wireless/iwlegacy/3945.c
 create mode 100644 drivers/net/wireless/iwlegacy/4965-mac.c
 create mode 100644 drivers/net/wireless/iwlegacy/4965.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl3945-base.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl4965-base.c

683K patch can be downloaded from:
http://people.redhat.com/sgruszka/iwlegacy-2011-11-16/0028-iwlegacy-rename-base-4965-and-3945-file-names.patch
