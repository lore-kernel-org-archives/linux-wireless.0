Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:58115 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752672AbaKGN25 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 08:28:57 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Fri,  7 Nov 2014 15:28:32 +0200
Message-Id: <1415366914-10997-1-git-send-email-luca@coelho.fi> (sfid-20141107_142906_439689_9F1987BA)
Subject: [PATCH 0/2] mac80211: fix a couple of mistakes in CSA code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Hi,

It seems that I made a couple of mistakes when publishing our CSA
patches to the mainline.  These two patches fix these problems.

--
Luca.

Luciano Coelho (2):
  mac80211: fix order of setting ch_switch and drv_pre_channel_switch
    call
  mac80211: add device_timestamp to the drv_pre_channel_switch trace

 net/mac80211/cfg.c   | 12 ++++++------
 net/mac80211/trace.h |  2 ++
 2 files changed, 8 insertions(+), 6 deletions(-)

-- 
2.1.1

