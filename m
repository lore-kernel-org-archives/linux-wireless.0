Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53704 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932549AbdCUQh2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 12:37:28 -0400
Subject: Re: Dell DW1601 (WIL6210)
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        Konstantin Koslowski <konstantin.koslowski@gmail.com>
References: <17d816d3dafddb3447e21808c130f596@rainloop.xkonni.de>
 <87var26cre.fsf@kamboji.qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>
From: Lior David <liord@codeaurora.org>
Message-ID: <70a1a2e0-dcde-ed26-4993-a93453e5cb2f@codeaurora.org> (sfid-20170321_174238_488205_D353CDC9)
Date: Tue, 21 Mar 2017 18:02:41 +0200
MIME-Version: 1.0
In-Reply-To: <87var26cre.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/21/2017 2:21 PM, Kalle Valo wrote:
> (adding wil6210 list)
> 
> "Konstantin Koslowski" <konstantin.koslowski@gmail.com> writes:
> 
>> I recently acquired a few Dell DW1601 cards and after a few initial
>> searches it sounded like they could be used to connect to each other.
>> Now it seems that they do not have the wifi connectivity enabled, just WBE.
>>
>> relevant lspci output:
>> 03:00.0 PCI bridge [0604]: Wilocity Ltd. Wil6200 PCI Express Root Port
>> [1ae9:0101] (rev 04)
>> 04:00.0 PCI bridge [0604]: Wilocity Ltd. Wil6200 PCI Express Port [1ae9:0200] (rev 04)
>> 04:02.0 PCI bridge [0604]: Wilocity Ltd. Wil6200 Wireless PCI Express
>> Port [1ae9:0201] (rev 14)
>> 04:03.0 PCI bridge [0604]: Wilocity Ltd. Wil6200 Wireless PCI Express
>> Port [1ae9:0201] (rev 14)
>> 05:00.0 Network controller [0280]: Qualcomm Atheros AR9462 Wireless
>> Network Adapter [168c:0034] (rev 01)
>>
>> So the wifi device does not show up. Seems it needs a different firmware.
> 
> I was told that this an older device and it only supports WBE, not
> Wi-Fi. So it's not actually supported by wil6210.
> 
Here are some alternative devices which have 11ad chip supported by wil6210 driver:
Acer has a few laptops with a compatible 11ad chip. You can go to this site:
http://www.acer.com/ac/en/US/content/professional-models/laptops/travelmatep6
Currently the 11ad models do not appear there but I hope it is just a temporary
shortage.
The TP-LINK AD7200 and NETGEAR NightHawk X10 routers contain 11ad which is
supported by wil6210:
http://www.tp-link.com/us/products/details/cat-5506_AD7200.html
https://www.netgear.com/landings/ad7200/

Thanks,
Lior
