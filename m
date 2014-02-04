Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:57260 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbaBDM7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 07:59:32 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: michal.kazior@tieto.com, johannes@sipsolutions.net,
	kvalo@adurom.com
Subject: [RCF/WIP 0/3] multi-vif/multi-channel CSA implementation
Date: Tue,  4 Feb 2014 14:59:24 +0200
Message-Id: <1391518767-25847-1-git-send-email-luca@coelho.fi> (sfid-20140204_135948_486745_013D765A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Hi,

These are the patches I've been working on.  There are still some
rough edges (check the TODOs) and this is work-in-progress.

The concept seems to work fine, with my very limited testing.

Please comment.  Now it's your chance to get your revenge for my
annoying comments! :P

--
Luca.

Luciano Coelho (3):
  mac80211: split ieee80211_vif_change_channel in two
  mac80211: implement channel switch for multiple vifs and multiple
    channels
  mac80211: add usage of CS channel reservation for STA

 net/mac80211/chan.c        | 190 ++++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/ieee80211_i.h |   8 ++
 net/mac80211/mlme.c        |  71 +++++++----------
 3 files changed, 207 insertions(+), 62 deletions(-)

-- 
1.8.5.3

