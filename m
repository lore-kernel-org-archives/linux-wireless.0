Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:57627 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbaHMRdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 13:33:42 -0400
Message-ID: <53EBA16F.9070305@create-net.org> (sfid-20140813_193344_942514_8CE464C4)
Date: Wed, 13 Aug 2014 19:33:35 +0200
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: About the TSFT field
References: <53EB355E.6090508@create-net.org>	 (sfid-20140813_120259_727542_9924FF23) <1407924311.21220.28.camel@jlt4.sipsolutions.net>
In-Reply-To: <1407924311.21220.28.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Inline...

On 13/08/14 12:05, Johannes Berg wrote:
> It's documented in the radiotap spec, but not all drivers are really
> doing the right thing here.

Found it. Thanks.

>> Also I do not know from which reference the TSFT is generated,
>> I mean two AP synchronized using NTP will have consistent
>> TSFT, which kind of error should I expect?
> 
> It's purely local time - no synchronisation happens.

Meaning that is the system time. right? What if I create an adhoc
interface together with the AP? According to the standard devices
in IBSS shall synch with each other using the tsf info in the beacon
frames. Is this behavior implemented by mac80211?

Thanks
R.
