Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46336 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbbIUPxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 11:53:46 -0400
Subject: Re: [PATCH] nl80211: Print reasons for errors in setting bitrates.
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1442610135-8696-1-git-send-email-greearb@candelatech.com>
 <1442838469.1876.1.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56002809.8010307@candelatech.com> (sfid-20150921_175352_870736_08811092)
Date: Mon, 21 Sep 2015 08:53:45 -0700
MIME-Version: 1.0
In-Reply-To: <1442838469.1876.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2015 05:27 AM, Johannes Berg wrote:
> On Fri, 2015-09-18 at 14:02 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Makes it easier to figure out why user-space calls are
>> failing.
>
> I'm aware of this problem, but I'm not going to gratuitously start
> printing to dmesg for this.
>
> There's a scheme being discussed for extended error numbers/messages,
> particularly for perf but it might be implemented for any syscall. We
> might be able to extend that to netlink in a different way, including
> the description in the (extended) netlink ack message.

I understand...I figured the patch might not be wanted.  A more general
solution would be welcome.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

