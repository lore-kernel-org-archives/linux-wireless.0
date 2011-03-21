Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:43382 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab1CUCAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Mar 2011 22:00:36 -0400
Received: from mail.lockie.ca (dyn-dsl-lh-98-124-36-5.nexicom.net [98.124.36.5])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p2L20WbG027785
	for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 22:00:32 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 75EE01E0426
	for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 22:00:31 -0400 (EDT)
Message-ID: <4D86B13F.10607@lockie.ca>
Date: Sun, 20 Mar 2011 22:00:31 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: why would IRQ change?
References: <4D866714.80503@lockie.ca> <AANLkTim_YELaSk4X4uRf_nsyAThK7SiMAq3rDD_MZVmb@mail.gmail.com> <4D86A311.2070404@lockie.ca> <AANLkTikFAvu9EHK6g51EEbrMsBoODwXZ4XWgtYUUpqjv@mail.gmail.com>
In-Reply-To: <AANLkTikFAvu9EHK6g51EEbrMsBoODwXZ4XWgtYUUpqjv@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/11 21:14, Julian Calaby wrote:
> On Mon, Mar 21, 2011 at 12:00, James <bjlockie@lockie.ca> wrote:
>> On 03/20/11 19:42, Julian Calaby wrote:
>>> On Mon, Mar 21, 2011 at 07:44, James <bjlockie@lockie.ca> wrote:
>>>> Is there a tool to list what devices are assigned what IRQ?
>>>>
>>>> This from an old kernel:
>>>> ieee80211 phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
>>>> mem=0xffffc900017a0000, irq=18
>>>>
>>>> This is from today:
>>>> ath9k 0000:02:09.0: PCI INT A -> Link[LNKB] -> GSI 17 (level, low) -> IRQ 17
>>>> ieee80211 phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
>>>> mem=0xffffc90001ba0000, irq=17
>>> AFAIK, PCI interrupts numbers are just sequential numbers assigned by
>>> Linux - there is no significance to them, they are just a number for
>>> tracking which interrupt is assigned to which device - there is no
>>> "IRQ17" or "IRQ18" anywhere in any actual hardware.
>>>
>>> Thanks,
>>>
>> I'm thinking maybe the IRQ sharing doesn't work right with this card.
> It's a PCI card. See: http://en.wikipedia.org/wiki/Conventional_PCI#Interrupts
>
> Thanks,
>
Interesting, thanks.
