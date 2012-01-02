Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62089 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab2ABHoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 02:44:12 -0500
Received: by wgbdr13 with SMTP id dr13so26345118wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jan 2012 23:44:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmok-aU4u=a_O7n1FOwD2cnd_eQMcyKzvYgXOSbZ=uSrHAA@mail.gmail.com>
References: <CAApCBGx28SbbmNpynCpKW9CyAsV5+c_fZ=1k9QAsKnXf4nDQEw@mail.gmail.com>
	<CAApCBGx7fHuQr87TnppE6FyX9d-1F0huUqgYhjv++8vmfov6zQ@mail.gmail.com>
	<4EF31325.2050408@openwrt.org>
	<CAApCBGwto0YxMKcirX_FJYaGw8K6Dcoxpn9P30=Mk-9oHJok+Q@mail.gmail.com>
	<CAJ-VmonyWC4JXrikuzxxaaGMReqq3VGhH+WLWjtN+8gTCvM7kg@mail.gmail.com>
	<4EF42F12.1000309@openwrt.org>
	<CAApCBGyrF4JSEGnq0USdUT8UvmyR2kRMCFh-2nmEeRR0FTCfEw@mail.gmail.com>
	<CAJ-Vmok-aU4u=a_O7n1FOwD2cnd_eQMcyKzvYgXOSbZ=uSrHAA@mail.gmail.com>
Date: Mon, 2 Jan 2012 09:44:11 +0200
Message-ID: <CAApCBGxgxLcij=u5VLPojk82afVffmBYP84pgFEOhFzZdjs=3g@mail.gmail.com> (sfid-20120102_084416_709959_6E249043)
Subject: Re: ar9390 failing AGC calibration on powerpc platform
From: wireless newbie <wnewbie72@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, openwrt-devel@lists.openwrt.org,
	Mohammed Shafi <shafi.wireless@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I tried 5ghz by changing hw_mode to 'a' and channel to 40. Still I get
the same error:

ath: Unable to reset hardware; reset status -5 (freq 2412 MHz)

That frequency makes me wonder if the change has really any affect?


2011/12/23 Adrian Chadd <adrian@freebsd.org>:
> Is it this bad behaved in 5ghz mode?
>
>
> adrian
>
> On 23 December 2011 01:03, wireless newbie <wnewbie72@gmail.com> wrote:
>>> iw wlan0 survey dump
>>
>> Here is what I got. Looks like its busy most of the time, doesn't it?
>>
>> Survey data from wlan0
>>        frequency:                      2412 MHz
>>        channel active time:            139291 ms
>>        channel busy time:              135849 ms
>>        channel receive time:           0 ms
>>        channel transmit time:          0 ms
>> Survey data from wlan0
>>        frequency:                      2417 MHz
>> Survey data from wlan0
>>        frequency:                      2422 MHz
>> Survey data from wlan0
>>        frequency:                      2427 MHz
>> Survey data from wlan0
>>        frequency:                      2432 MHz
>> Survey data from wlan0
>>        frequency:                      2437 MHz
>> Survey data from wlan0
>>        frequency:                      2442 MHz
>> Survey data from wlan0
>>        frequency:                      2447 MHz
>> Survey data from wlan0
>>        frequency:                      2452 MHz
>> Survey data from wlan0
>>        frequency:                      2457 MHz
>> Survey data from wlan0
>>        frequency:                      2462 MHz
>> Survey data from wlan0
>>        frequency:                      5180 MHz
>> Survey data from wlan0
>>        frequency:                      5200 MHz
>> Survey data from wlan0
>>        frequency:                      5220 MHz
>> Survey data from wlan0
>>        frequency:                      5240 MHz
>> Survey data from wlan0
>>        frequency:                      5745 MHz
>> Survey data from wlan0
>>        frequency:                      5765 MHz
>> Survey data from wlan0
>>        frequency:                      5785 MHz
>> Survey data from wlan0
>>        frequency:                      5805 MHz
>> Survey data from wlan0
>>        frequency:                      5825 MHz
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
