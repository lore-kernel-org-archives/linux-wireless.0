Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:58846 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbZKMB6n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 20:58:43 -0500
Received: by gxk26 with SMTP id 26so2663802gxk.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 17:58:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258051800.2347.127.camel@localhost.localdomain>
References: <1d91afb90911112231n54696c5fh950ba0102740d444@mail.gmail.com>
	 <45e8e6c40911112302s7c5c3e5cq496289512410ecba@mail.gmail.com>
	 <200911120847.44150.sturmflut@lieberbiber.de>
	 <1258051444.2347.124.camel@localhost.localdomain>
	 <1258051800.2347.127.camel@localhost.localdomain>
Date: Fri, 13 Nov 2009 09:58:48 +0800
Message-ID: <1d91afb90911121758o6109145cl23894afda8bcbee2@mail.gmail.com>
Subject: Re: Looking for the datasheet of zd1211rw...
From: tomas zheng <tomaswlan.zheng@gmail.com>
To: Dan Williams <dcbw@redhat.com>,
	Simon Raffeiner <sturmflut@lieberbiber.de>,
	Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan and Guys,

Thanks very much for your information.
Very appreciated.
I will try this today.

But why I can not find the detail datasheet about 88W83xxxx on
http://www.marvell.com and some googling?
Anyone happened has it? Or , where should I go if I want it?

Thanks,

K T


On Fri, Nov 13, 2009 at 2:50 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Thu, 2009-11-12 at 10:44 -0800, Dan Williams wrote:
>> On Thu, 2009-11-12 at 08:47 +0100, Simon Raffeiner wrote:
>> > Am Donnerstag, 12. November 2009 08:02:36 schrieben Sie:
>> >
>> > > It looks like a Marvell device (and therefore not a zd1211) from what
>> > > you posted.
>> >
>> > It is a Marvell Libertas device, but it seems the USB ID is not claimed by the existing drivers ("libertas" and "libertas_tf").
>>
>> It's a softmac device, likely an 8335-based card.  The 'mwl8k' driver
>> upstream is the closest match, but mwl8k doesn't yet have support for
>> the older softmac cards like the 8335 or 8361/8362 TopDog series.
>
> I lie, it's a usb8338 (W833810).  There's code for this driver
> "around" (mrvl_cb82 is the name) but it's the old vendor driver based on
> net80211:
>
> http://git.kernel.org/?p=linux/kernel/git/linville/marvell.git;a=summary
>
> drivers/net/wireless/mrvl_cb82/driver/mwl_usb.c
>
> Dan
>
>
>
