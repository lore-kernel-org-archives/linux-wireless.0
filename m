Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25918 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166Ab2EAT17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 15:27:59 -0400
Message-ID: <4FA03939.4080307@qca.qualcomm.com> (sfid-20120501_212837_371460_CA4B357F)
Date: Tue, 1 May 2012 22:27:53 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jonathan Bagg <jbagg@lenbrook.com>
CC: Anthony Ginger <mapfly@gmail.com>,
	<linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: ath6kl hostapd
References: <CAK0tYSKLhALwUca2LPiRLfXTK-Qt3Oh3Lvk=V272AXdb=aAP7w@mail.gmail.com> <4F4B25F5.4090204@qca.qualcomm.com> <4F8546C7.40703@qca.qualcomm.com> <4FA036B6.7040002@lenbrook.com>
In-Reply-To: <4FA036B6.7040002@lenbrook.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/01/2012 10:17 PM, Jonathan Bagg wrote:
> On 12-04-11 04:54 AM, Kalle Valo wrote:
>>
>> With latest firmware 3.2.0.144 (which I submitted to linux-firmware.git
>> yesterday) and latest hostapd from git I can create a WPA-PSK network
>> using hostapd and my Nokia N900 succesfully connected to the network and
>> I was able to ping N900.
>>
>> If this is not working for you I recommend updating to the latest firmware.
>
> When you tried hostapd on the N900, did you use a kernel built from your 
> https://github.com/kvalo/ath6kl.git or from compat-wireless?

Just to clarify: I was running hostapd on my x86 box which has ar6003
and I used N900 as the client connecting to the x86 box.

I used ath6kl.git for my tests. I use compat-wireless very little (if
any) in my tests.

Kalle
