Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35755 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab1BHRKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 12:10:36 -0500
Message-ID: <4D517908.6020003@candelatech.com>
Date: Tue, 08 Feb 2011 09:10:32 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] mac80211:  Make STA disconnect messages warn instead
 of debug.
References: <1297115078-27773-1-git-send-email-greearb@candelatech.com> <87y65q7hc3.fsf@purkki.adurom.net>
In-Reply-To: <87y65q7hc3.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2011 06:04 AM, Kalle Valo wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This makes them more easily seen in /var/log/messages
>> and the console, for instance.
>
> Messages like these are in the category "business as usual", which
> happens frequently when the device is moved. IMHO they are not really
> warnings. I'm worried that making the messages more visible might
> scare the users too much.

To me it seems more useful than the network up/down messages that
are already printed from the networking core.

That said, I don't feel strongly about this change, and it's certainly
an easy patch for me to carry in my own tree.

Thanks
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

