Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48352 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab1FVE7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 00:59:35 -0400
Received: by bwz15 with SMTP id 15so437253bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 21:59:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308395545.31756.11.camel@wwguy-ubuntu>
References: <BANLkTim83iarV-J08JAsVtfLR2ziqLs=iQ@mail.gmail.com>
	<1308395545.31756.11.camel@wwguy-ubuntu>
Date: Tue, 21 Jun 2011 23:59:33 -0500
Message-ID: <BANLkTi=360xAMZXZm5QpkOzkqmfQb8X-uQ@mail.gmail.com> (sfid-20110622_065942_716897_5A3DF071)
Subject: Re: iwlagn: Problems with Intel Wifi Link 1000 on newer kernels
From: Erik Hardesty <ehardesty@gmail.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wey,
As far as I can tell the config is setup properly for iwlagn but
here is a link to my complete config: http://pastebin.com/yrynheyx

Router information:
Model: Buffalo WZR-HP-G300NH
Firmware: DD-WRT v24SP2 (Buffalo official version)
Band: 2.4ghz
Channel: 9
Channel Width: 40mhz
Mode: NG-Mixed

While my laptop does have bluetooth I don't believe the module for it is loaded.
Also, I've not been able to connect any other AP that I've tried.

Thanks,
Erik

On Sat, Jun 18, 2011 at 6:12 AM, wwguy <wey-yi.w.guy@intel.com> wrote:
> Hi Erik,
>
> n Thu, 2011-06-16 at 23:14 -0700, Erik Hardesty wrote:
>> Having trouble with iwlagn in kernels newer than 2.6.38.
>> I've tried 2.6.39 and 3.0rc3 and both give me the same problem.
>> I have the latest intel firmware installed on the system. Both
>> iwlwifi-1000-3.ucode
>> and iwlwifi-1000-5.ucode are in /lib/firmware
>>
>> Note: 2.6.38 does not exhibit the same issue and works fine.
>>
>> Symptom: Able to scan for access points but unable to connect.
>> I am unable to connect to any router regardless of it being open, WEP, or WPAx.
>>
>> lspci -v | grep -i wifi:
>>
>> 03:00.0 Network controller: Intel Corporation WiFi Link 1000 Series
>>     Subsystem: Intel Corporation WiFi Link 1000 Series 1000BGN
>>
>> dmesg:
>>
>> myhost kernel: wlan0: direct probe to <ap> (try 1)
>> myhost kernel: wlan0: direct probe to <ap> (try 2)
>> myhost kernel: wlan0: direct probe to <ap> (try 3)
>> myhost kernel: wlan0: direct probe to <ap> timed out
>> myhost kernel: iwlagn 0000:03:00.0: fail to flush all tx fifo queues
>>
> There were a driver split happen to iwlagn between .38 and .39. Could
> you please check your .config to make sure all the configuration set
> correctly.
>
> I will also need more information on your setup, such as band and
> channel, AP model...
>
> One more thing, do you have bluetooth in your system? is it on by
> default?
>
> Thanks
> Wey
>
>
