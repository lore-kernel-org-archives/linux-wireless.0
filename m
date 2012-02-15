Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm27-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.227]:28090
	"HELO nm27-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754577Ab2BOKlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:41:19 -0500
Message-ID: <EB4DA10182044DDE952EF2C4B81CF6B3@7CF9T2X> (sfid-20120215_114123_283380_83A343D5)
From: "Fu yingang" <yingang.fu@borqs.com>
To: "Luciano Coelho" <coelho@ti.com>, "Eliad Peller" <eliad@wizery.com>
Cc: <linux-wireless@vger.kernel.org>
References: <1328178131-28938-1-git-send-email-eliad@wizery.com> <1329301121.19569.43.camel@cumari>
Subject: Re: [PATCH 0/3] wl12xx: re-enable auto-arp
Date: Wed, 15 Feb 2012 18:41:18 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi, all

Where can i find the latest code?

Thanks
Yingang

----- Original Message ----- 
From: "Luciano Coelho" <coelho@ti.com>
To: "Eliad Peller" <eliad@wizery.com>
Cc: <linux-wireless@vger.kernel.org>
Sent: Wednesday, February 15, 2012 6:18 PM
Subject: Re: [PATCH 0/3] wl12xx: re-enable auto-arp


> On Thu, 2012-02-02 at 12:22 +0200, Eliad Peller wrote:
>> auto-arp used to cause various issues when enabled. however,
>> after some fixes both in the driver and fw side, it seems to
>> work well. re-enable it.
>>
>> Eliad Peller (3):
>>   wl12xx: consider encryption and QoS in auto arp template
>>   wl12xx: Revert "wl12xx: disable auto-arp"
>>   wl12xx: configure arp filtering only after association
>
> Applied this set, thanks.
>
> -- 
> Cheers,
> Luca.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

