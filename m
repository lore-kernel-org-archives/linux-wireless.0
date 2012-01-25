Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2595 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192Ab2AYKAe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 05:00:34 -0500
Message-ID: <4F1FD2AA.9020708@broadcom.com> (sfid-20120125_110050_202004_E96370D5)
Date: Wed, 25 Jan 2012 11:00:10 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Francis Moreau" <francis.moro@gmail.com>
cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: kernel 3.2.1: BUG: scheduling while atomic:
 swapper/0/0/0x10000100
References: <CAC9WiBgpBCWZVjAQkJWSpXhC_dK1KKPfAHZvxVgaLV8BUsc41Q@mail.gmail.com>
 <4F1FBAA9.4040405@broadcom.com>
 <CAC9WiBjpsLuJhzw+vZsPC2bA73mad444Gq32DRL_gCri2MqaMw@mail.gmail.com>
In-Reply-To: <CAC9WiBjpsLuJhzw+vZsPC2bA73mad444Gq32DRL_gCri2MqaMw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/25/2012 09:35 AM, Francis Moreau wrote:
> Hi Arend,
> 
> On Wed, Jan 25, 2012 at 9:17 AM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 01/24/2012 04:59 PM, Francis Moreau wrote:
>>> Hi,
>>>
>>> Just in case someone is interested, I've been hit by this:
>>>
>>> [  236.734640] BUG: scheduling while atomic: swapper/0/0/0x10000100
>>
>> I hit that problem yesterday as well on 3.3.0-rc1. I suspected it came
>> from my development changes on brcmfmac, but you are not using that.
> 
> I'm not sure it's related to the brcmfmac, because the RFKILL switch
> was off when it happened.
> 
> Were you writting/reading from/to a SD card by any chances when it did trigger ?
> 

Nope. It was a USB device driver. Maybe it was conincidental that it
happened shortly after loading the driver, but I tend to mistrust my own
stuff ;-). I posted a question in my issue yesterday (see [1]).

Gr. AvS

[1] https://lkml.org/lkml/2012/1/24/83

