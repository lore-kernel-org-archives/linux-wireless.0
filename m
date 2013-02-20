Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34038 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934133Ab3BTSmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 13:42:19 -0500
Message-ID: <51251907.7020203@candelatech.com> (sfid-20130220_194229_941831_E3A3B7A8)
Date: Wed, 20 Feb 2013 10:42:15 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.7.6+:  WARNING: at net/mac80211/iface.c:705 ieee80211_do_stop
References: <5112F8D9.5060206@candelatech.com>   (sfid-20130207_014415_868355_33170FE8) <1360327897.29851.21.camel@jlt4.sipsolutions.net>  <51250B2D.3040708@candelatech.com> <1361384263.8579.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1361384263.8579.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2013 10:17 AM, Johannes Berg wrote:
> On Wed, 2013-02-20 at 09:43 -0800, Ben Greear wrote:

>> Any further thoughts on this?  If you have a suggested patch to
>> test I can test it today..I have a test case that reliably reproduces
>> this currently...
>
> http://git.kernel.org/?p=linux/kernel/git/davem/net-next.git;a=commitdiff;h=572078be54856bf751af9a43d501ffb8d09b1ea7

Thanks..that seems to fix the problem for me.

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

