Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57161 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbcBZJsB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 04:48:01 -0500
Message-ID: <1456480074.5284.0.camel@sipsolutions.net> (sfid-20160226_104810_817396_0D7D9C5D)
Subject: Re: [PATCH] mac80211_hwsim: Set global RRM capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Fengguang Wu <lkp@intel.com>, Kalle Valo <kvalo@codeaurora.org>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>, kbuild-all@01.org,
	linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>,
	"Ye, Xiaolong" <xiaolong.ye@intel.com>
Date: Fri, 26 Feb 2016 10:47:54 +0100
In-Reply-To: <20160226081836.GA6470@wfg-t540p.sh.intel.com>
References: <201602251751.QT2WO50c%fengguang.wu@intel.com>
	 <87y4a8lz44.fsf@purkki.adurom.net>
	 <20160226081836.GA6470@wfg-t540p.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-02-26 at 16:18 +0800, Fengguang Wu wrote:
> 
> > I think this build failure is because mac80211_hwsim is an
> > exception to
> > other wireless drivers and is applied via mac80211-next. Should we
> > add
> > an entry for mac80211_hwsim to MAINTAINERS with the correct git
> > tree? I
> > think kbuild test robot follows MAINTAINERS file nowdays (or at
> > least I
> > understood that's the plan).
> 
> That's right. The robot parses MAINTAINERS when judging which tree
> to apply LKML patches to.
> 

Great. I'll add a commit to make mac80211_hwsim just part of the
MAC80211 entry.

johannes
