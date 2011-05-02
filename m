Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:56473 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab1EBXqu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 19:46:50 -0400
Date: Mon, 2 May 2011 19:46:49 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Roland Dreier <roland@kernel.org>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
In-Reply-To: <alpine.DEB.2.02.1104261923390.3894@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1105021944560.14515@p34.internal.lan> (sfid-20110503_014711_343853_EFCFBBD5)
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <alpine.DEB.2.02.1104251432560.23304@p34.internal.lan> <BANLkTimV4Nse58oQsWZWKzMbC7Ldm4mRLA@mail.gmail.com> <alpine.DEB.2.02.1104260619420.8361@p34.internal.lan> <alpine.DEB.2.02.1104261753210.3894@p34.internal.lan>
 <4DB74788.2000908@lwfinger.net> <alpine.DEB.2.02.1104261923390.3894@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Tue, 26 Apr 2011, Justin Piszcz wrote:

>
>
> On Tue, 26 Apr 2011, Larry Finger wrote:
>
>>> 
>>> I am trying a different driver now: rt2870sta
>>> I've read a few reports this may be the 'proper' one to use.
>>> So far so good, no lag or anything and I did not have to set power off
>>> either.
>> 
>> Driver rtl2870sta is not the proper one to use. In fact, a patch to delete 
>> rt2860sta and rt2870sta from the kernel was queued yesterday, and they will 
>> be gone by the time 2.6.40 is released.
>> 
>> New firmware for rt2800usb was just accepted into the linux-firmware git 
>> tree. Please obtain a copy and try it.
>> 
>> Larry
>>

Hi,

Just an update, this driver has been solid so far:
rt2870sta

With the Media Link 150 USB stick, not a single crash yet--
The rt2800usb driver is laggy and crashes the kernel (as of 2.6.38.x)--
Is there a possiblity to get rtl2870sta into the mainline?
It is the best wireless driver I've used for Linux with various usb wifi
adapters--

# uptime
  19:44:28 up 4 days, 10:16,  2 users,  load average: 1.51, 1.56, 1.25

Justin.

