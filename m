Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39491 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab1BIO0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:26:23 -0500
Message-ID: <4D52A40B.8020302@candelatech.com>
Date: Wed, 09 Feb 2011 06:26:19 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] mac80211:  Make STA disconnect messages warn instead
 of debug.
References: <1297115078-27773-1-git-send-email-greearb@candelatech.com>	<87y65q7hc3.fsf@purkki.adurom.net> <4D517908.6020003@candelatech.com> <87tygd76nw.fsf@purkki.adurom.net>
In-Reply-To: <87tygd76nw.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2011 04:07 AM, Kalle Valo wrote:
> Ben Greear<greearb@candelatech.com>  writes:
>
>>> Messages like these are in the category "business as usual", which
>>> happens frequently when the device is moved. IMHO they are not really
>>> warnings. I'm worried that making the messages more visible might
>>> scare the users too much.
>>
>> To me it seems more useful than the network up/down messages that
>> are already printed from the networking core.
>
> You are not a normal user :) But what networking core messages are you
> referring to? I don't recall seeing anything like that.

ADDRCONF(NETDEV_CHANGE): sta6: link becomes ready
ADDRCONF(NETDEV_CHANGE): sta5: link becomes ready
ADDRCONF(NETDEV_CHANGE): sta4: link becomes ready

Possibly I previously hacked on the console logging levels and forgot
about it...

>
>> That said, I don't feel strongly about this change, and it's certainly
>> an easy patch for me to carry in my own tree.
>
> I also don't have any strong opinion about this, just voiced my
> concern.

No problem.  One final note:  These will only show if someone has
compiled in wireless debugging...

We can let the maintainer make the call :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
