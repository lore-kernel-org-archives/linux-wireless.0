Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:54023 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3CBMrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 07:47:07 -0500
Received: by mail-we0-f177.google.com with SMTP id d7so3209362wer.8
        for <linux-wireless@vger.kernel.org>; Sat, 02 Mar 2013 04:47:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5131D400.3070506@erley.org>
References: <CABFmVg5sPub5Q4n+7PnkUn7weQLEUabONeJQZY6aFS2yFZAf2Q@mail.gmail.com>
	<CABFmVg5AaTG-F_myEA=WGdYpnwN9X=QfLcjKvwJ1-SUX0quaOg@mail.gmail.com>
	<CABFmVg5J6nWfBFL1VAsD+V3X_xPD6v4wLz0X5Wv4p082Trdshw@mail.gmail.com>
	<5131D400.3070506@erley.org>
Date: Sat, 2 Mar 2013 14:47:04 +0200
Message-ID: <CABFmVg4_-fjU1iKaqTCYZKeMe7QKKvXCgcMuB6jx+D4mzQ_F6Q@mail.gmail.com> (sfid-20130302_134711_864964_710303E4)
Subject: Re: Fwd: Intel Wifilink 5100 AGN - Does it support Access Point
 Infrastructure Mode ?
From: Abdelmuhaimen Seaudi <aseaudi@gmail.com>
To: Pat Erley <pat-lkml@erley.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Pat,
So this means no way the Intel WiFiLink 5100 AGN will run in AP master
mode, correct ?
Note that it can run in Windows using program like Virtual Router, and
I confirmed I was able to connect to my workstation wifi. Note also
that it is not using Adhoc mode, it was using AP Infrastructure mode.
Thanks for your confirmation.

On 3/2/13, Pat Erley <pat-lkml@erley.org> wrote:
> On 03/02/2013 04:51 AM, Abdelmuhaimen Seaudi wrote:
>> Hello iwlwifi support,
>> I want to run my Wifi Intel WifiLink 5100 AGN in Access Point
>> Infrstructure Mode, so that I can connect via WiFi with other devices
>> to my workstation.
>> This is under Ubuntu Linux 12.10.
>> I have tried setting the wlan0 to run in master mode, but it gives me
>> error, as shown below.
>> Is it possible to run this WiFi radio in AP Infrstrucutre mode ? How ?
>> Thanks,
>>
>
> <SNIP>
>
>> 	Supported interface modes:
>> 		 * IBSS
>> 		 * managed
>> 		 * monitor
>> 	software interface modes (can always be added):
>> 		 * monitor
>
> It also looks like this chipset doesn't support master mode.
>
> Pat Erley
>


-- 
Thanks and best regards

Abdel-Muhaimen Seaudi
CCIE # 25265
aseaudi@gmail.com
Tel.: +2010-0538-7426
