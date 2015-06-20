Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35660 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbbFTW2C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2015 18:28:02 -0400
Received: by wiga1 with SMTP id a1so46630103wig.0
        for <linux-wireless@vger.kernel.org>; Sat, 20 Jun 2015 15:28:00 -0700 (PDT)
Message-ID: <5585E8EE.2000005@gmail.com> (sfid-20150621_002821_076793_22E30F97)
Date: Sun, 21 Jun 2015 00:27:58 +0200
From: Blue Glacier <blueglacier414@gmail.com>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: "No association and the time event is over already..."
References: <5585B209.3040406@gmail.com> <CANUX_P0DYFVqxVHg6B8ZXLiLv97Gu8JuiXcUEA8rvPMW8+Jb2Q@mail.gmail.com>
In-Reply-To: <CANUX_P0DYFVqxVHg6B8ZXLiLv97Gu8JuiXcUEA8rvPMW8+Jb2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

yes, already tried to disable and re-enable WiFi. Didn't help.

I guess AP means Access Point. It is a "FRITZ!Box 6360 Cable (um)". I 
tried to reboot it. 15 minutes later it suddenly worked - but only for 
two hours. Now the connection is broken again.

While ping times out, I sometimes seem to be able to load websites - but 
it takes almost 10 minutes and many elements are missing. I am also 
repeatedly asked for my WiFi-password, which worked until yesterday.

I compared the md5 hash sums of the driver image (iwlwifi-7265-9.ucode) 
that I have installed and the one that is available through the link you 
gave me, and the sums are equal. Therefore, I think it doesn't make 
sense to try the other image.

I don't know if it is a good idea to install a different kernel on 
Debian Stable.

Jens

Am 20.06.2015 um 22:01 schrieb Emmanuel Grumbach:
> On Sat, Jun 20, 2015 at 9:33 PM, Blue Glacier <blueglacier414@gmail.com> wrote:
>> Hello,
>>
>> my Intel Wireless 7265 chip suddenly stopped working. The Network Manager
>> shows that I am connected, but I cannot even ping to my home router. I
>> didn't change anything on my system.
> What is your AP? Can you reproduce consistently? If you disable WiFi
> and re-enable WiFi from the Network Manager, does it help?
>
>> The output of dmesg looks interesting:
>>
>> [  507.737606] wlan0: Connection to AP c0:25:06:ce:d2:e9 lost
>> [  507.806070] cfg80211: Calling CRDA for country: DE
>> [  508.379770] cfg80211: Calling CRDA for country: DE
>> [  511.332818] wlan0: authenticate with c0:25:06:ce:d2:e9
>> [  511.338625] wlan0: send auth to c0:25:06:ce:d2:e9 (try 1/3)
>> [  511.341600] wlan0: authenticated
>> [  511.343813] wlan0: associate with c0:25:06:ce:d2:e9 (try 1/3)
>> [  511.350128] wlan0: RX AssocResp from c0:25:06:ce:d2:e9 (capab=0x431
>> status=0 aid=8)
>> [  511.353700] wlan0: associated
>> [  511.645582] iwlwifi 0000:03:00.0: No association and the time event is
>> over already...
>> [  511.645642] wlan0: Connection to AP c0:25:06:ce:d2:e9 lost
>> [  511.688174] cfg80211: Calling CRDA to update world regulatory domain
>>
>> (repeated numerous times)
>>
>> I am using Debian 8 Jessie (stable) together with the firmware from your
>> server (iwlwifi-7265-9.ucode). The Kernel Version is 3.16.0-4-amd64.
> Can you try a more recent kernel with a more recent firmware?
> You can check https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/core_release
> if you want to update your driver without changing your kernel.
>
>> Any idea how to fix this?
>
>> Jens
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
