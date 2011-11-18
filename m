Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756968Ab1KRIXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:23:08 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8N8QI026384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:23:08 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 66/77] iwlegacy: indentions and whitespaces
Date: Fri, 18 Nov 2011 09:22:28 +0100
Message-Id: <1321604559-10707-66-git-send-email-sgruszka@redhat.com> (sfid-20111118_092315_523855_FA9CA8D1)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Process iwlegacy source files using:

indent -npro -l500 -nhnl
indent -npro -kr -i8 -ts8 -sob -l80 -nbbo -ss -ncs -cp1 -il0 -psl

Plus manual compilation fixes.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-debug.c |  698 +++++-----
 drivers/net/wireless/iwlegacy/3945-mac.c   | 1143 +++++++--------
 drivers/net/wireless/iwlegacy/3945-rs.c    |  252 ++--
 drivers/net/wireless/iwlegacy/3945.c       |  920 ++++++------
 drivers/net/wireless/iwlegacy/3945.h       |  115 +-
 drivers/net/wireless/iwlegacy/4965-calib.c |  354 +++---
 drivers/net/wireless/iwlegacy/4965-debug.c | 1178 ++++++++--------
 drivers/net/wireless/iwlegacy/4965-mac.c   | 2173 ++++++++++++++--------------
 drivers/net/wireless/iwlegacy/4965-rs.c    | 1094 +++++++-------
 drivers/net/wireless/iwlegacy/4965.c       |  741 +++++-----
 drivers/net/wireless/iwlegacy/4965.h       |  184 +--
 drivers/net/wireless/iwlegacy/commands.h   |  123 +-
 drivers/net/wireless/iwlegacy/common.c     | 1927 +++++++++++++------------
 drivers/net/wireless/iwlegacy/common.h     |  934 ++++++------
 drivers/net/wireless/iwlegacy/csr.h        |   69 +-
 drivers/net/wireless/iwlegacy/debug.c      |  965 +++++++------
 drivers/net/wireless/iwlegacy/prph.h       |   25 +-
 17 files changed, 6439 insertions(+), 6456 deletions(-)

900K patch can be downloaded from:
http://people.redhat.com/sgruszka/iwlegacy-2011-11-16/0066-iwlegacy-indentions-and-whitespaces.patch
