Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50278 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757648Ab2EJI7N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 04:59:13 -0400
Message-ID: <4FAB835F.4090808@tieto.com> (sfid-20120510_105919_062634_54617BDB)
Date: Thu, 10 May 2012 10:59:11 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/7] mac80211: move oper_channel to sdata
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>  <1336632282-2278-8-git-send-email-michal.kazior@tieto.com> <1336635100.4334.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336635100.4334.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2012-05-10 at 08:44 +0200, Michal Kazior wrote:
>
>> +	/* cfg80211 arbitrates multi-channel */
>> +	if (local->hw.wiphy->flags&  WIPHY_FLAG_ENFORCE_COMBINATIONS)
>> +		return true;
>
> This no longer exists, but that's just arbitrating
> multi-virtual-interface, not necessarily multi-channel, I think?

Oh, my bad. You're right.

On a second thought I think this condition shouldn't be here yet 
(putting aside that the flag does no longer exist).


-- 
Pozdrawiam / Best regards, Michal Kazior.
