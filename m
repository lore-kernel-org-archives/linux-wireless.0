Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:50444 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab2FZMh0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:37:26 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC v3] initial channel context implementation
Date: Tue, 26 Jun 2012 14:37:15 +0200
Message-ID: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com> (sfid-20120626_143729_495459_0E1AA5B2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here's another respin of channel context patches.

Changes:

 - moved ieee80211_chan_mode
 - updated chanctx_conf comment
 - replaced vif_list with refcount
 - added lockdeps
 - channel type downgrading support
   (when a channel context is unassigned from a vif
    channel type is recalculated for the remaining vifs
    sharing the same channel context)


-- Pozdrawiam / Best regards, Michal Kazior.

