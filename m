Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36037 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932218AbdCFWZn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 17:25:43 -0500
Received: by mail-wm0-f46.google.com with SMTP id n11so75803797wma.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Mar 2017 14:25:42 -0800 (PST)
Subject: Re: Usage of WoWLAN with iwlwifi driver (Device phy0 failed to
 suspend async: error -16)
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <cc035655-0869-f7d7-bdb4-61e7a38b7fc8@googlemail.com>
 <1487938277.2540.13.camel@sipsolutions.net>
 <5d69cf9b-1113-835a-8423-3796586eae20@googlemail.com>
 <1487965047.30601.2.camel@sipsolutions.net>
 <6337fa40-adcc-b889-1842-16e0f316ea3e@googlemail.com>
 <1488444909.8390.11.camel@sipsolutions.net>
 <0cd984fd-3d26-15b2-03ce-69cdb7c0e434@googlemail.com>
 <1488479939.23555.1.camel@sipsolutions.net>
 <37f7bd69-9a0e-7e49-7035-9e6f2cfef260@googlemail.com>
 <1488787876.5761.1.camel@sipsolutions.net>
 <a4d62049-b406-0321-11c1-109c61527df5@googlemail.com>
 <1488837079.27057.13.camel@sipsolutions.net>
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <d9d1a287-2b52-06da-fb3d-0949b1214a4a@googlemail.com> (sfid-20170306_232548_639103_3FA049DD)
Date: Mon, 6 Mar 2017 23:25:39 +0100
MIME-Version: 1.0
In-Reply-To: <1488837079.27057.13.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 06.03.2017 um 22:51 schrieb Johannes Berg:
>> I realized I also have a Win10 installation on that machine - and may
>> as well try WoWLAN with it. 
>> Enabling (in the dreaded device manager) wake via the WiFi device,
>> magic packet mode, I also cannot wake the machine. 
> 
> Ok. I didn't even know it was easy to actually get this configured on
> Windows :)
At least I hope it's so easy in Windows (and that's what "the internet" told me). 
I'm also not sure whether that's fully sufficient, since I never got it to work
(at least not with WiFi ;-) ). 
Also, it seems extremely driver dependent
to configure more complex stuff than magic packet (i.e. anything else is not in the normal
device manager GUI, but in the driver-specific options for each device). 

>> So if it was a driver bug, it would have to be present both in
>> Windows and Linux drivers - but I guess it's just another case
>> of broken system firmware *sigh*. 
> 
> Agree, that seems rather unlikely. Unless there's some kind of "magic"
> setup that the UEFI wants, and the driver knows nothing about ... also
> seems unlikely though.
> 
>> And that's even though it's a pretty recent Clevo W230SD-based
>> machine (which I considered decently widespread)
>> with unlocked UEFI (so I see almost all options), but of course
>> nothing related to ACPI wakeup. 
>> But I guess widespread alone does not help ;-). 
> 
> Yeah, too bad. Want to ask the manufacturer for help? ;-)
I believe my Chinese is not good enough to contact the original manufacturer - and the W230SD is already not manufactured
anymore, I think (even though it still was current a year ago or so). 
I also doubt the German company which relabelled the Clevo barebone (Schenker) will care. 
The other laptop is >4 years old now, and an Alienware machine with dedicated GPU (only), so they probably did not care too much about any power saving / ACPI wakeup feature at all. 

But anyways, WoW-LAN for me would just have been a nice feature, but is not essential for survival. 

With cheap can-be-always-on-devices like a Raspberry Pi, I guess WoW-LAN in consumer-grade laptops is becoming less and less interesting. 
Also, I personally do not have a must-have usecase for it. 

Thanks anyways! :-)
	Oliver
