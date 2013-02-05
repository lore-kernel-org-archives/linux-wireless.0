Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:62399 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab3BEVYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 16:24:10 -0500
Received: by mail-qa0-f44.google.com with SMTP id bv4so2012118qab.3
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2013 13:24:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51116A33.9070207@lwfinger.net>
References: <51102B22.20702@gmail.com>
	<CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com>
	<511163BA.7060902@gmail.com>
	<51116A33.9070207@lwfinger.net>
Date: Tue, 5 Feb 2013 22:18:32 +0100
Message-ID: <CAOAX8-ndqhzkRWCVa+FGtuAk+U3obpG0Zjim4+QWqKjD7UONnQ@mail.gmail.com> (sfid-20130205_222414_577896_437DBA3E)
Subject: Re: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
From: Thomas Rosenkranz <tom.rosary@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In Windows it calls "Realtek RTL8188CUS WLAN USB Slim Solo"

2013/2/5 Larry Finger <Larry.Finger@lwfinger.net>:
> On 02/05/2013 01:55 PM, Xose Vazquez Perez wrote:
>>
>> On 02/05/2013 12:00 AM, Thomas Rosenkranz wrote:
>>
>> Larry, are you able to identify the chip of that device
>> with the 8192cu output ?
>>
>> what should he do ? open the device to see the chip ??
>
>
> What difference does it make what chip it has? It is obviously some flavor
> of RTL8188CU/RTL8192CU that is different enough that it does not work with
> the kernel version of rtl8192cu. A few months ago, I ran across a new B-CUT
> RTL8188CE that took new programming for rtl8192ce, and I suspect this device
> also has the B-CUT chip.
>
> The crash on unloading is a known fault of the vendor driver. It happens
> with devices that work OK with the standard rtl8192cu. I have no desire to
> find out what causes the crash.
>
> If someone wants to supply me with a sample of this 0bda:819a device, I'll
> make it work in the kernel. I have no desire to try to purchase one on my
> own.
>
> Larry
>
>
>
