Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57221 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2KUPYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 10:24:41 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 0/2] brcmsmac fixes for wireless-next
Date: Wed, 21 Nov 2012 09:24:29 -0600
Message-Id: <1353511471-5994-1-git-send-email-seth.forshee@canonical.com> (sfid-20121121_162444_271006_06632A74)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are patches to fix the sparse warnings introduced by my recent
patch series.

Thanks,
Seth

Seth Forshee (2):
  brcmsmac: Remove unused wlc_prio2prec_map and _BRCMS_PREC_* constants
  brcmsmac: Remove stray argument from debug macro

 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   27 --------------------
 2 files changed, 1 insertion(+), 28 deletions(-)

