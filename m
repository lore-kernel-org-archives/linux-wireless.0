Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52251 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760755AbXFGUnO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 16:43:14 -0400
Date: Thu, 7 Jun 2007 22:43:15 +0200
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: IEEE802.11e/WMM TS management and DLS support
Message-ID: <20070607224315.6dadffca@griffin.suse.cz>
In-Reply-To: <20070606082152.GA28639@mail.intel.com>
References: <20070606082152.GA28639@mail.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 6 Jun 2007 16:21:54 +0800, Zhu Yi wrote:
> This is a patch series for IEEE802.11e/WMM support against
> linux-2.6.22-rc4.
> 
> [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
> [PATCH 2/3] mac80211: IEEE802.11e/WMM TS management and DLS support
> [PATCH 3/3] mac80211: debugfs support for TSM and DLS

John,

I see you already applied those patches. I haven't had a time to look
at the second patch in this resent version yet, but even from the first
and third one it's clear they still need a lot of work (for example,
adding cfg80211 support instead of that debugfs interface isn't going
to be a few lines long patch).

Please revert them.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
