Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3011 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab3HNSQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 14:16:48 -0400
Message-ID: <520BC97E.9070505@broadcom.com> (sfid-20130814_201652_163917_C232A1B0)
Date: Wed, 14 Aug 2013 20:16:30 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "David Herrmann" <dh.herrmann@gmail.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Jonas Gorski" <jogo@openwrt.org>,
	"Maximilian Engelhardt" <maxi@daemonizer.de>,
	"David Costa" <david@zarel.net>
Subject: Re: [RFT 00/13] brcmsmac: bcm4313 iPA related patches
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
 <CANq1E4TO8radaMFoLjiwhSq2JAFqcLm8UMQvaq9oJRHiWz=60w@mail.gmail.com>
 <520A9B0D.3050006@broadcom.com>
 <CANq1E4SOcT765CTFCR=xywBuMkOs5oru-NBqwHM=Jj_dfwtvkw@mail.gmail.com>
In-Reply-To: <CANq1E4SOcT765CTFCR=xywBuMkOs5oru-NBqwHM=Jj_dfwtvkw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/14/2013 12:33 PM, David Herrmann wrote:
> Hi
>
> On Tue, Aug 13, 2013 at 10:46 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 08/13/2013 10:09 PM, David Herrmann wrote:
>>>
>>> Hi
>>>
>>> On Tue, Aug 13, 2013 at 10:03 PM, Arend van Spriel <arend@broadcom.com>
>>> wrote:
>>>>
>>>> This series replaces the patch "[PATCH 12/12] brcmsmac: support 4313iPA"
>>>> with Message-ID: <1376130450-29746-13-git-send-email-arend@broadcom.com>.
>>>>
>>>> It has been split up into individual patches. Please test this series
>>>> especially if you had issues with the original commit b6fc28a that was
>>>> reverted.
>>>>
>>>> Cc: Jonas Gorski <jogo@openwrt.org>
>>>> Cc: David Herrmann <dh.herrmann@gmail.com>
>>>> Cc: Maximilian Engelhardt <maxi@daemonizer.de>
>>>> Cc: David Costa <david@zarel.net>
>>>
>>>
>>> Is this available in a public branch that I can merge? And what should
>>> be used as base? 3.11-rc5? linux-next?
>>
>>
>> Indeed I should have mentioned. It applies on v3.11-rc5 for sure. Did not
>> try linux-next.
>
> All 13 patches applied cleanly on top of 3.11-rc5, everything works
> fine even after a dozen of reconnects to different networks. No
> additional delays.
>
> Consider this whole series:
> Tested-by: David Herrmann <dh.herrmann@gmail.com>
>
> card info: Broadcom Corporation BCM4313 802.11b/g/n (0a5c:219c)
> (builtin into my old Intel Atom N450 board)
> I tested with 802.11g networks. I have only a/g networks here. I don't
> know whether that matters.

As this series modifies the phy code, I would say no.

Thanks for verifying this works for you.

Regards,
Arend

