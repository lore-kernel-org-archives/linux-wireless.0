Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56456 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab2GLSt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 14:49:28 -0400
Received: by pbbrp8 with SMTP id rp8so4121581pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 11:49:28 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH v5 0/5] wireless: rebase onus patches
Date: Thu, 12 Jul 2012 11:49:16 -0700
Message-Id: <1342118961-13008-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20120712_204932_508210_72B9B2DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

This v5 series rebases the onus patches on to today's mac80211-next.
John, once this is applied you can simply apply the v4 driver updates
given that they should apply without any issues.

Luis R. Rodriguez (5):
  cfg80211: add CONFIG_CFG80211_CERTIFICATION_ONUS
  cfg80211: add cellular base station regulatory hint support
  cfg80211: rename reg_device_remove() to wiphy_regulatory_deregister()
  cfg80211: make regulatory_update() static
  cfg80211: remove regulatory_update()

 include/linux/nl80211.h  |   32 ++++++++++++
 include/net/regulatory.h |    5 ++
 net/wireless/Kconfig     |   21 ++++++++
 net/wireless/core.c      |   10 ++--
 net/wireless/nl80211.c   |   23 ++++++++-
 net/wireless/reg.c       |  125 ++++++++++++++++++++++++++++++++++++++++------
 net/wireless/reg.h       |    8 +--
 7 files changed, 201 insertions(+), 23 deletions(-)

-- 
1.7.10.rc1.22.gf5241

