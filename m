Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:23260 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbeG3M6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 08:58:04 -0400
Subject: Re: ath9k and 16 VAP interfaces?
To: michael-dev@fami-braun.de,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <8ecda6f3-68ab-5752-c8de-4086d21ba309@candelatech.com>
 <EB834EF3-21B2-4E6F-BEA8-1411407310F0@fami-braun.de>
From: Matthias May <matthias.may@neratec.com>
Message-ID: <0896f150-13f8-daae-c956-f60a2f7feeaf@neratec.com> (sfid-20180730_132336_090367_94E37668)
Date: Mon, 30 Jul 2018 13:13:33 +0200
MIME-Version: 1.0
In-Reply-To: <EB834EF3-21B2-4E6F-BEA8-1411407310F0@fami-braun.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30/07/18 11:40, michael-dev@fami-braun.de wrote:
> Do you mean AP interfaces as required for multiple BSS/SSIDs?
> 
> I'm running a patched ath9k to have hostapd run >8 BSS on a single radio.
> It works fine since years.
> 
> Regards,
> M. Braun
> 
> 
> Am 27. Juli 2018 15:35:28 MESZ schrieb Ben Greear <greearb@candelatech.com>:
>> Hello,
>>
>> Has anyone tried making ath9k able to support 16 vAP interfaces on a
>> single
>> radio?  I seem to recall that there were limitations regarding beacon
>> timers and such, and that is why the current limit is 8?
>>
>> Thanks,
>> Ben
>>
>> -- 
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
> 

Are these patches available somewhere?
I'm interested to play with them :)

BR
Matthias
