Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.235]:40443 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759507AbZBDTT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 14:19:28 -0500
Received: by qb-out-0506.google.com with SMTP id q18so428335qba.17
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 11:19:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3ace41890902041018mdc6a5eanc79cebeb5759001e@mail.gmail.com>
References: <cf70f0210902041010h24932f9ao3e5c9f6a243b483d@mail.gmail.com>
	 <3ace41890902041018mdc6a5eanc79cebeb5759001e@mail.gmail.com>
Date: Thu, 5 Feb 2009 00:49:26 +0530
Message-ID: <cf70f0210902041119l21631fd4hcde779bfca198e24@mail.gmail.com> (sfid-20090204_201943_491358_DD20AA20)
Subject: Re: Regarding Belkin wireless USB adapter
From: Shivdas Gujare <shivdas.tech@gmail.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hin-Tak,
Thanks for your quick reply.

I needs to recheck about "open or WEP network", but from properties it says
"Security->WPA personal".
 One thing I observed while trying to configure from command line.
if I do "ifconfig wlan0 up", it doesn't show "RUNNING".
I can scan the channels using iwlist properly but, assigning access point using
"iwconfig wlan0 ap access_pt", doesn't work for me and shows "ap not assigned"

Thanks and Regards,
Shivdas

On 2/4/09, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> On Wed, Feb 4, 2009 at 6:10 PM, Shivdas Gujare <shivdas.tech@gmail.com>
> wrote:
>> Hi,
>> I am trying to use Belkin Wireless G USB adapter(uses trl8187 driver)
>> on ARM board. I am tesing this with x86 and ARM board (BeagleBoard).
>>
>> My problem is, this adapter works fine with my Ubuntu
>> laptop(v2.6.29-rc2) using NetworkManager because of udev.
>>
>> I tried to run wpa_supplicant from command line as,
>>  wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf
>> It gives error "Failed to read or parse configuration
>> '/etc/wpa_supplicant.conf'"
>> Because, my laptop doesn't have /etc/wpa_supplicant.conf file, But
>> still wireless network works fine.
>>
>> I don't have wpa_supplicant in ARM rootfs, hence want to know
>> Does wpa_supplicant is necessary to make this USB wireless adapter work?
>>
>> Also, is /etc/wpa_supplicant.conf necessary in rootfs, since device
>> works fine without this file on my laptop.
>
> Hmm, wpa_supplicant.conf contains security info, and wpa keys, etc and
> such. Are you on an open or WEP network?
> If so, you don't even need wpa_supplicant - just do iwconfig, etc.
>
>>
>> Thanks for your help.
>>
>> Regards,
>> Shivdas
>>
>
