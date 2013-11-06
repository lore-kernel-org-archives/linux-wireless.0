Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39525 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3KFTJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 14:09:23 -0500
Message-ID: <527A93DF.80006@candelatech.com> (sfid-20131106_200926_348428_B56FA24E)
Date: Wed, 06 Nov 2013 11:09:19 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Crash related to scanning in 'ath' tree (3.12.0-rc5 + minor patches)
References: <527A9124.5000306@candelatech.com>  (sfid-20131106_195744_890692_15B02E5D) <1383764624.14307.46.camel@jlt4.sipsolutions.net>
In-Reply-To: <1383764624.14307.46.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/06/2013 11:03 AM, Johannes Berg wrote:
> On Wed, 2013-11-06 at 10:57 -0800, Ben Greear wrote:
>> This is from the 'ath' tree, which is 3.12.0-rc5.  There are just a few printk patches
>> to mac80211, and some moderate amount of patches to ath10k.  I left the ath10k logs in
>> this crash in case it provides some clue, but I think it may not be an ath10k problem
>> as I have seen what I think is the same crash a few times before in 3.11+ with ath9k.
> 
> You couldn't have seen the same crash with ath9k - it's in
> ieee80211_prep_hw_scan() which doesn't get called in that case.

Ok, you are right..the old one was a bit different.

See my email titled:

iee80211_scan_work crash in 3.11.0+ kernel.

from 9/12/2013.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

