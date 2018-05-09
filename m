Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41050 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934140AbeEIIvu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 04:51:50 -0400
Message-ID: <1525855900.6910.5.camel@sipsolutions.net> (sfid-20180509_105154_415962_6F49D4D4)
Subject: Re: [mac80211-next:master 12/14]
 drivers/net//wireless/ath/wil6210/debugfs.c:1245:1: warning: the frame size
 of 1600 bytes is larger than 1024 bytes
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@codeaurora.org>,
        kbuild test robot <lkp@intel.com>
Cc: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Maya Erez <merez@codeaurora.org>
Date: Wed, 09 May 2018 10:51:40 +0200
In-Reply-To: <87efil2p2o.fsf@purkki.adurom.net> (sfid-20180509_104722_363915_8DC71EC9)
References: <201805090154.h4Cokbx2%fengguang.wu@intel.com>
         <87efil2p2o.fsf@purkki.adurom.net> (sfid-20180509_104722_363915_8DC71EC9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-05-09 at 11:47 +0300, Kalle Valo wrote:
> 
> I guess these warnings come because Toke's patch increased size of
> struct cfg80211_tid_stats (which is included in struct station_info) and
> both wil6210 and qtnfmac allocate a struct station_info from stack? 

Yes.

> Can
> someone send a fix for the drivers?

I guess Toke/I should do that through my tree.

johannes
