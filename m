Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:54750 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659AbaFQJQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 05:16:47 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFC 0/3] brcmfmac: provide band info upon wiphy registration
Date: Tue, 17 Jun 2014 11:16:18 +0200
Message-ID: <1402996581-10764-1-git-send-email-arend@broadcom.com> (sfid-20140617_111653_355155_5DFC0304)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This short series rely on a cfg80211 API so making this a RFC. It
applies to master branch of the wireless-next repository.

Arend van Spriel (3):
  brcmfmac: move attach and detach functions in wl_cfg80211.c
  cfg80211: expose cfg80211_disable_40mhz_24ghz module parameter
  brcmfmac: update band and regulatory info before wiphy_register()

 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 240 ++++++++++-----------
 include/net/cfg80211.h                             |   9 +
 net/wireless/core.c                                |   6 +
 3 files changed, 130 insertions(+), 125 deletions(-)

-- 
1.9.1

