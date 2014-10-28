Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:52971 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaJ1OHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:07:03 -0400
Message-ID: <544FA303.5060303@broadcom.com> (sfid-20141028_150708_461098_6F66FA6D)
Date: Tue, 28 Oct 2014 15:06:59 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	Oleksij Rempel <linux@rempel-privat.de>
CC: Etna <etna@openmailbox.org>, <linux-wireless@vger.kernel.org>
Subject: Re: MediaTek WiFi hardware support in upstream kernel
References: <544DB5A8.7090405@openmailbox.org> <20141027152026.GB19976@tuxdriver.com> <544E8CB4.3000607@rempel-privat.de> <20141028134608.GA26283@tuxdriver.com>
In-Reply-To: <20141028134608.GA26283@tuxdriver.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28-10-14 14:46, John W. Linville wrote:
> On Mon, Oct 27, 2014 at 07:19:32PM +0100, Oleksij Rempel wrote:
>> Am 27.10.2014 um 16:20 schrieb John W. Linville:
>>> On Mon, Oct 27, 2014 at 11:02:00AM +0800, Etna wrote:
>>>> I am not a developer, but I stumbled upon this just a couple of days ago in
>>>> the OpenWRT forums:
>>>>
>>>> https://forum.openwrt.org/viewtopic.php?id=53215
>>>>
>>>> In short, MediaTek is looking for volunteers to help get their drivers
>>>> mainlined in the upstream kernels; this includes drivers for their USB and
>>>> PCI wifi hardware under both the MediaTek and Ralink brands. They are
>>>> willing to provide "chip info, reference driver, dev board, etc" and even
>>>> some degree of sponsorship, apparently subject to their management's
>>>> approval.
>>>>
>>>> In exchange, they require that the volunteers fulfill the following
>>>> requirements:
>>>> - skilled in wifi driver development
>>>> - provide a suitable schedule / roadmap
>>>> - be able to get the code mainlined in the official linux kernel.
>>>>
>>>> Those who are keen on taking up the task can contact the original poster at
>>>> hua.shao[AT]mediatek.com
>>>>
>>>> **Disclaimer: I am in no way related to, or under the employ of MediaTek or
>>>> Ralink. I am only posting this here because I have a handful of MT wifi
>>>> chips which I hope to see being supported in the upstream kernel so that I
>>>> can actually use them under Linux,
>>>
>>> Well, this is mostly good to see.  I hope there is someone that wants
>>> to take-up the cause!
>>>
>>> If someone is interested in working-on the project above but for
>>> whatever reason doesn't want to deal with MediaTek on their own,
>>> feel free to contact me.  I'll try to be helpful however I can.
>>>
>>> Thanks,
>>>
>>> John
>>
>>
>> Sounds interesting and as perfect possibility to learn. I would like to
>> do it, but i have two concerns:
>> - i never wrote an wifi driver from scratch.
> 
> FWIW, I think MediaTek already has some form of drivers.  With that
> said, it might be easier to write new mac80211-based ones than to
> adapt the existing ones.
> 
>> - i'm seeking for a job. It means if i will find one, this project will
>> get lower priority.
> 
> No one can ask anything more.
> 
>> If nobody has problems with this two points, then i'm ok.
> 
> It sounds like we have a volunteer!  Let me know if you need any
> specific help or guidance.

During LPC Felix mentioned GPLed mediatek driver for their 11ac
chipset(s?). It is on github:

https://github.com/openwrt/mtk-wifi-gpl

Regards,
Arend

