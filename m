Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:17548 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbaA0VgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 16:36:17 -0500
Message-ID: <52E6D148.5020703@broadcom.com> (sfid-20140127_223634_149784_3659A64F)
Date: Mon, 27 Jan 2014 22:36:08 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Alessandro Gnagni <enterprise.nx@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Trying to add support of 802.11ac broadcom chpiset to openwrt
References: <52821B80.6000305@gmail.com>	<52826A82.3010505@broadcom.com> <CAJ-Vmo=LtKsGPbvjQ01VQSad-vKCkq5usRaGcD-WdZPcnG7SrQ@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=LtKsGPbvjQ01VQSad-vKCkq5usRaGcD-WdZPcnG7SrQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/27/2014 08:10 PM, Adrian Chadd wrote:
> On 12 November 2013 09:50, Arend van Spriel <arend@broadcom.com> wrote:
>> On 11/12/2013 01:13 PM, Alessandro Gnagni wrote:
>>>
>>> Hi,
>>> i am trying to implement on a smart city network a solution based on
>>> high end home routers like the asus RT-AC66U.
>>> we want to use openwrt for that but unfortunately the broadcom driver
>>> isn't yet supported.
>>> I have one rt-ac66u here for development, there is anything that i can
>>> do for help?
>>> i came here after a suggestion of one member on openwrt forum:
>>> https://forum.openwrt.org/viewtopic.php?pid=217341#p217341
>>>
>>> i also read this past email:
>>> http://www.spinics.net/lists/linux-wireless/msg110443.html
>>
>>
>> Not sure what 11ac chipset is used. The upstream brcm80211 drivers currently
>> only support one 11ac chipset, ie. the bcm4335. This is a single stream with
>> SDIO host interface supported by the fullmac driver brcmfmac.
>>
>> For chipsets like 4360 we need to add AC phy support to brcmsmac. So far we
>> do not have green light to do so.
>>
>> Regards,
>> Arend
> 
> Hiya,
> 
> Is this still the status quo? I'd like to start porting updated
> broadcom support to FreeBSD for Apple Macintosh users who would like
> 11ac NIC support.

Hi Adrian,

Interesting. A while ago someone wanted to port brcmsmac to a BSD flavor
(not sure which one). Now brcmsmac as-is today uses BCMA bus driver
which goes under GPL-v2, which may or may not be a problem. Apple Mac
users probably have 4360 and that hurdle is also still there.

Gr. AvS
