Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59226 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab1BQVzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 16:55:14 -0500
Received: by fxm20 with SMTP id 20so3095939fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Feb 2011 13:55:13 -0800 (PST)
Message-ID: <4D5D97EB.9020406@lwfinger.net>
Date: Thu, 17 Feb 2011 15:49:31 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: Ivo Van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2x00: Update rt2860/rt2870 firmware
References: <4D09081A.3060404@gmail.com>	<4D5D7A09.7000203@gmail.com> <AANLkTimVPVTA8ZocHbnjE+a321ZtuH5cFNi4pPhLUotu@mail.gmail.com> <4D5D9594.7010904@gmail.com>
In-Reply-To: <4D5D9594.7010904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2011 03:39 PM, Xose Vazquez Perez wrote:
> On 02/17/2011 08:43 PM, Ivo Van Doorn wrote:
>
>> I have already send a patch to update the
>> firmwares some time ago already.
>>
>> If there is another update, feel free to send a new patch
>> to the linux-firmware maintainer.
>
> I did it _ten_ months ago, but no luck. So I asked you to do it.
> Again to /dev/null. Thanks anyway.
>
> next step?

Did your proposed change have a good/strong reference to the license file in 
WHENCE? My experience is that the maintainer drops changes that do not, usually 
without comment. I also found that "found in hex form in source" did not work 
the way it did for your previous versions. Only when I provided a license from 
the vendor did I get anywhere. Is LICENCE.ralink-firmware.txt valid for this new 
version?

Larry
