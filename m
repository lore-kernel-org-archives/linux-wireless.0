Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53368 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbZDWISY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 04:18:24 -0400
Received: by fxm2 with SMTP id 2so398670fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 01:18:22 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"Guy\, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: calculate maximum sleep interval
References: <1240418677.30082.3.camel@johannes.local>
	<874owfdctm.fsf@litku.valot.fi>
	<1240474574.30082.171.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 23 Apr 2009 11:18:20 +0300
In-Reply-To: <1240474574.30082.171.camel@johannes.local> (Johannes Berg's message of "Thu\, 23 Apr 2009 10\:16\:14 +0200")
Message-ID: <87r5zjbx6b.fsf@litku.valot.fi> (sfid-20090423_101828_847317_A2070D32)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-04-23 at 10:55 +0300, Kalle Valo wrote:
>
>> > + * @max_sleep_interval: the maximum number of beacon intervals to sleep for
>> > + *	before checking the beacon for a TIM bit (managed mode only); this
>> > + *	value will be only achievable between DTIM frames, the hardware
>> > + *	needs to check for the multicast traffic bit in DTIM beacons.
>> > + *	This variable is valid only when the CONF_PS flag is set.
>> 
>> I would prefer to call it max_sleep_period. Or maybe even wakeup period,
>> because it's about waking up here.
>> 
>> For me interval, for example beacon interval, means that the unit is TU.
>> But this might be just me.
>
> Good argument. I'll post a follow-up patch to rename it (to make it
> easier).

Thanks.

-- 
Kalle Valo
