Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40825 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbaJ2QCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 12:02:03 -0400
Message-ID: <54510F7B.4040102@candelatech.com> (sfid-20141029_170216_936902_0099FD3D)
Date: Wed, 29 Oct 2014 09:02:03 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211-hwsim:  add frequency attribute to netlink pkts
References: <1414447486-10385-1-git-send-email-greearb@candelatech.com> <1414598110.1827.19.camel@jlt4.sipsolutions.net>
In-Reply-To: <1414598110.1827.19.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/29/2014 08:55 AM, Johannes Berg wrote:
> On Mon, 2014-10-27 at 15:04 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Add frequency attribute when sending to user-space over
>> netlink socket.  The frequency is currently ignored when
>> receiving from user-space.
> 
> Applied.

Do you have any suggestions for how to deal with pkts
received (from user-space netlink) on a frequency that does
not match the current hwsim radio's center frequency?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

