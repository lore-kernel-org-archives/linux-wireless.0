Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63326 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1DKQFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 12:05:07 -0400
Received: by vws1 with SMTP id 1so4233322vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 09:05:05 -0700 (PDT)
Message-ID: <4DA326A9.9060904@gmail.com>
Date: Mon, 11 Apr 2011 12:04:57 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc oddity
References: <4D9FCC70.1020805@gmail.com>	<19871.62035.829719.402615@gargle.gargle.HOWL>	<4DA311F3.6010007@gmail.com> <19875.7684.859710.807182@gargle.gargle.HOWL>
In-Reply-To: <19875.7684.859710.807182@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/11 11:28, Sujith wrote:
> Richard Farina wrote:
>> The following commit causes extreme sadness:
>> [ 4094.241243] usb 2-5: new high speed USB device using ehci_hcd and
>> address 3
>> [ 4095.550452] usb 2-5: ath9k_htc: Transferred FW: ar9271.fw, size: 51312
>> [ 4095.816072] ath9k_htc 2-5:1.0: ath9k_htc: HTC initialized with 33 credits
>> [ 4159.812888] usb 2-5: USB disconnect, address 3
>> [ 4159.929317] ath: Couldn't reset chip
>> [ 4159.929321] ath: Unable to initialize hardware; initialization status: -5
>> [ 4159.929323] ath: Unable to initialize hardware; initialization status: -5
>> [ 4159.929340] Failed to initialize the device
>> [ 4160.012603] ath9k_htc: probe of 2-5:1.0 failed with error -22
>> [ 4160.012771] usbcore: registered new interface driver ath9k_htc
>> [ 4163.595059] usb 2-5: new high speed USB device using ehci_hcd and
>> address 4
>> [ 4164.018920] usb 2-5: ath9k_htc: Transferred FW: ar9271.fw, size: 51312
>> [ 4164.284420] ath9k_htc 2-5:1.0: ath9k_htc: HTC initialized with 33 credits
>>
>> I'm guessing because I need the mentioned firmware update? Where can I
>> get it? Or better yet can you (this is almost laughable considering the
>> ralink thread right now) get it into linux-firmware? Or is the needed
>> firmware update an unstable thing?
> The new FW has to be formally/officially tested before it is merged into
> linux-firmware.
>
>> Either way I can wait on the firmware-version fix but where can I find
>> the patch that shows fixes the "driver: usb" issue? Your obviously shows
>> properly :-)
> http://linuxwireless.org/en/users/Drivers/ath9k_htc
Sorry for being a bit dim on this but which part of this exactly fixes 
the ethtool driver function?  I'm guessing it is in the patchset and the 
firmware is only required if I want to detect the firmware version? Or 
do I really need experimental firmware to make it detect the driver 
properly?

Also, when you say experimental do you mean it's all pretty experimental 
or just the AP stuff is? I'm guessing the firmware is based on the 
current firmware so the station mode et al should be (approximately) as 
stable at the released firmware and only the AP parts are experimental.

Thanks,
Rick Farina

> Sujith
>

