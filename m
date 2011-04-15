Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4645 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab1DOMkp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 08:40:45 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] staging: brcm80211: removed ASSERTs from util dir
Date: Fri, 15 Apr 2011 14:40:29 +0200
Message-ID: <1302871231-8739-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Roland Vossen (2):
  staging: brcm80211: removed ASSERTs from util dir, part 1
  staging: brcm80211: removed ASSERTs from util dir, part 2

 drivers/staging/brcm80211/util/bcmotp.c   |   36 +++++------------
 drivers/staging/brcm80211/util/bcmsrom.c  |   40 +------------------
 drivers/staging/brcm80211/util/bcmutils.c |   30 ++------------
 drivers/staging/brcm80211/util/bcmwifi.c  |    4 --
 drivers/staging/brcm80211/util/hnddma.c   |   62 ++--------------------------
 drivers/staging/brcm80211/util/nicpci.c   |   14 +------
 drivers/staging/brcm80211/util/qmath.c    |    1 -
 7 files changed, 21 insertions(+), 166 deletions(-)


