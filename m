Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64790 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759851Ab1ENDlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 23:41:06 -0400
Received: by gwaa18 with SMTP id a18so1086853gwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 20:41:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DCDC7A0.2020504@candelatech.com>
References: <4DCDC068.9060307@candelatech.com>
	<4DCDC7A0.2020504@candelatech.com>
Date: Sat, 14 May 2011 11:41:04 +0800
Message-ID: <BANLkTikv9jhZaC=+Rtn5DmHADEJkvqo3KQ@mail.gmail.com> (sfid-20110514_054504_468745_68C54539)
Subject: Re: Can't get hostapd to start, channels are all passive-scanning?
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What's the regulatory domain of the NIC?

Is it some strange race condition with CRDA?


Adrian

On 14 May 2011 08:06, Ben Greear <greearb@candelatech.com> wrote:
> On 05/13/2011 04:36 PM, Ben Greear wrote:
>>
>> Any idea what would cause all of my 5Ghz channels to be passive
>> scanning (which keeps hostapd from being able to use them, evidently)
>>
>> Frequencies:
>> * 5180 MHz [36] (17.0 dBm) (passive scanning, no IBSS)
>> * 5200 MHz [40] (17.0 dBm) (passive scanning, no IBSS)
>> * 5220 MHz [44] (17.0 dBm) (passive scanning, no IBSS)
>> * 5240 MHz [48] (17.0 dBm) (passive scanning, no IBSS)
>> * 5260 MHz [52] (18.0 dBm) (passive scanning, no IBSS, radar detection)
>> * 5280 MHz [56] (18.0 dBm) (passive scanning, no IBSS, radar detection)
>> * 5300 MHz [60] (18.0 dBm) (passive scanning, no IBSS, radar detection)
>> * 5320 MHz [64] (18.0 dBm) (passive scanning, no IBSS, radar detection)
>
> Bleh...reboot and it comes up looking more normal (first 4 are usable, at
> least).
>
> Will post again if I can reproduce it.
>
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
