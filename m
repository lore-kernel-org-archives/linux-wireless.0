Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46684 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0HQPt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 11:49:28 -0400
Received: by ewy23 with SMTP id 23so3096952ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Aug 2010 08:49:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimYs3fcSTKYwa60P0_OtumBoHJidYFZuLhXeimZ@mail.gmail.com>
References: <AANLkTimMhW7OX3DT7A3EDNaOnr577KmTv5w9C_mz19TG@mail.gmail.com>
	<AANLkTin0R6k0_GoSEN8aJ8t_fTJw9h_N_0etcxAokv6N@mail.gmail.com>
	<AANLkTinPR-Fp7u6vFq9LsY93myS4QzyMpF3R0NydmHYv@mail.gmail.com>
	<AANLkTinkx+FjrAR48dziDR2kX48JRcjm3SF7jhhi4_oM@mail.gmail.com>
	<AANLkTimYs3fcSTKYwa60P0_OtumBoHJidYFZuLhXeimZ@mail.gmail.com>
Date: Tue, 17 Aug 2010 12:49:25 -0300
Message-ID: <AANLkTins9BRDA5A8qyfr27RV9LxD3rv0SG2u0hcjaL2j@mail.gmail.com>
Subject: Re: [RFT] BCM4312 users with DMA errors, please test!
From: Arthur Moreira <arthur.moreira@gmail.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

all right
but i try to test with pacience, but i am newer in module compilation and paths
if you create a topic only for the device 4353 is better.

and obvios, ever... sorry for the bad english, but a talk from brazil.

if you can, try to post the step by step for the path aplication..
for the diff file and the path file... i know to aply the path for the
path comand (path <# file)
but i dont know the essencial.

if you send me modules for test. tks.
and the steps



              Arthur Moreira




2010/8/16 Gábor Stefanik <netrolller.3d@gmail.com>:
> 2010/8/16 Arthur Moreira <arthur.moreira@gmail.com>:
>> Ok, tks Gábor
>>
>> i will wait, i need much of this card working in monitor mode for
>> tests and demonstration and my organization. i work with security in
>> my city. and i dont want to plug another card, like usb ou pciexpreess
>> card than a original embedded.
>>
>> if you need a help to tests and beta version of driver or modules
>> call me
>>
>>
>>               Arthur Moreira
>
> Well, I post any testing requests on the list, so you will probably
> see them here.
>
> Also, please use the Reply to All button when replying to a list!
>
>>
>> 2010/8/16 Gábor Stefanik <netrolller.3d@gmail.com>:
>>> 2010/8/16 Arthur Moreira <arthur.moreira@gmail.com>:
>>>> Hi,
>>>> I have a BCM4353 card, with the  hybrid module  wl work fine to find
>>>> and conect to networks.
>>>> But, a want to put the card in monitor mode.
>>>>
>>>> (my card is a 802.11bgN mini card, in a dell vostro)
>>>>
>>>> this path will help me? and.. how to aply the path? the comand path $#
>>>> < file    ???
>>>> tks
>>>>
>>>>
>>>>               Arthur Moreira
>>>>
>>>
>>> No, this patch is only for BCM4312 devices, not the BCM43224 that you
>>> have (there is no such thing as a "BCM4353" AFAIK - PCI device IDs
>>> don't map directly to chip IDs!). Your card is an N-PHY, probably
>>> revision 4 or 5 (you can see the revision by adding 14e4:4353 to the
>>> list of PCI IDs in ssb, then looking for the "FOUND UNSUPPORTED PHY"
>>> line in dmesg). We are working on N-PHYs, revisions <=2 will likely be
>>> usable soon; rev.3 and newer will take longer, however. (It is
>>> possible that this patch will also be needed for N-PHYs if they show
>>> similar DMA errors to the 4312, but it is certainly not enough to get
>>> N-PHYs to work.)
>>>
>>>>
>>>>
>>>>
>>>> 2010/8/16 Gábor Stefanik <netrolller.3d@gmail.com>:
>>>>> Hello Everyone!
>>>>>
>>>>> If you are experiencing DMA errors on a BCM4312, please test the
>>>>> attached patch. It implements the PCI-E SERDES workaround, which the
>>>>> hybrid driver is applying during early init to LP-PHY cards, and which
>>>>> is a good candidate for the cause of the DMA error.
>>>>> Note that this is not a final patch & it may cause collateral damage
>>>>> for non-4312 cards; if it helps the 4312 problem, I will submit a
>>>>> cleaned-up version.
>>>>>
>>>>> Thanks,
>>>>> Gábor
>>>>>
>>>>
>>>
>>>
>>>
>>> --
>>> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>>>
>>
>
>
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>
