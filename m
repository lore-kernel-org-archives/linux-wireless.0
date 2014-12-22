Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:18419 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaLVNNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2014 08:13:38 -0500
Message-ID: <549818FE.1090707@broadcom.com> (sfid-20141222_141341_836606_9B33E6E1)
Date: Mon, 22 Dec 2014 14:13:34 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Franky Lin <frankyl@broadcom.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] brmc80211: dont use jiffies for BSS TSF
References: <20120313125702.703540202@sipsolutions.net>	 <20120313125919.370791280@sipsolutions.net>	 (sfid-20120313_140421_642123_6BC8E250) <1419253089.1890.13.camel@sipsolutions.net>
In-Reply-To: <1419253089.1890.13.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/22/14 13:58, Johannes Berg wrote:
> By the way - I know now that the proprietary Broadcom driver has the
> same bug, to the point where this is apparently getting encoded into the
> Android framework.
>
> I urge you to fix this issue there as well. If an absolute "last
> updated" timestamp is needed (and "last seen [ms] ago" isn't sufficient)
> then new API will be needed.

Sorry, seem to have missed the original patches somehow. Guess because 
it says *brmc*80211.

Regards,
Arend
