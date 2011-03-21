Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:40736 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab1CUBAH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Mar 2011 21:00:07 -0400
Received: from mail.lockie.ca (dyn-dsl-lh-98-124-36-5.nexicom.net [98.124.36.5])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p2L102JS025641
	for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 21:00:03 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 0111F1E0390
	for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 21:00:01 -0400 (EDT)
Message-ID: <4D86A311.2070404@lockie.ca>
Date: Sun, 20 Mar 2011 21:00:01 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: why would IRQ change?
References: <4D866714.80503@lockie.ca> <AANLkTim_YELaSk4X4uRf_nsyAThK7SiMAq3rDD_MZVmb@mail.gmail.com>
In-Reply-To: <AANLkTim_YELaSk4X4uRf_nsyAThK7SiMAq3rDD_MZVmb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/11 19:42, Julian Calaby wrote:
> On Mon, Mar 21, 2011 at 07:44, James <bjlockie@lockie.ca> wrote:
>> Is there a tool to list what devices are assigned what IRQ?
>>
>> This from an old kernel:
>> ieee80211 phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
>> mem=0xffffc900017a0000, irq=18
>>
>> This is from today:
>> ath9k 0000:02:09.0: PCI INT A -> Link[LNKB] -> GSI 17 (level, low) -> IRQ 17
>> ieee80211 phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
>> mem=0xffffc90001ba0000, irq=17
> AFAIK, PCI interrupts numbers are just sequential numbers assigned by
> Linux - there is no significance to them, they are just a number for
> tracking which interrupt is assigned to which device - there is no
> "IRQ17" or "IRQ18" anywhere in any actual hardware.
>
> Thanks,
>
I'm thinking maybe the IRQ sharing doesn't work right with this card.

