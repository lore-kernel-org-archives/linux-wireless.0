Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59195 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab1DKQ7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 12:59:43 -0400
Received: by vws1 with SMTP id 1so4282718vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 09:59:43 -0700 (PDT)
Message-ID: <4DA33379.5020708@gmail.com>
Date: Mon, 11 Apr 2011 12:59:37 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc oddity
References: <4D9FCC70.1020805@gmail.com>	<19871.62035.829719.402615@gargle.gargle.HOWL>	<4DA311F3.6010007@gmail.com>	<19875.7684.859710.807182@gargle.gargle.HOWL>	<4DA326A9.9060904@gmail.com> <19875.10497.371960.179673@gargle.gargle.HOWL>
In-Reply-To: <19875.10497.371960.179673@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/11 12:14, Sujith wrote:
> Richard Farina wrote:
>> Sorry for being a bit dim on this but which part of this exactly fixes
>> the ethtool driver function?  I'm guessing it is in the patchset and the
>> firmware is only required if I want to detect the firmware version? Or
>> do I really need experimental firmware to make it detect the driver
>> properly?
> The ethtool fix is part of the patchset (specifically patch no. 3),
> and the new FW is required if the patchset is used.
Patch number 3 seems to fix only the firmware version grabbing.  Am I 
misunderstanding the part or is the driver name grabbing fixed somewhere 
else in a different place? In linus tree driver shows as "usb", Your 
ethtool output showed driver properly as "ath9k_htc".

-Rick
>> Also, when you say experimental do you mean it's all pretty experimental
>> or just the AP stuff is? I'm guessing the firmware is based on the
>> current firmware so the station mode et al should be (approximately) as
>> stable at the released firmware and only the AP parts are experimental.
> Yes, the new version is based on the current FW and the AP stuff is experimental.
> Station mode should ideally not have any problems, but since the firmware
> has had a fairly invasive cleanup, one can never know. :)
>
> Sujith
>

