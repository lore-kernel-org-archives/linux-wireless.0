Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:37588 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932126Ab1GAXVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 19:21:38 -0400
Message-ID: <4E0E567C.4010003@boundarydevices.com> (sfid-20110702_012141_293105_2DBCEC89)
Date: Fri, 01 Jul 2011 16:21:32 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
MIME-Version: 1.0
To: "Krakowski, Oz" <ozk@ti.com>
CC: mangesh gadre <mangeshgadre07@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: WL1271: WLAN_IRQ not working
References: <4E0942CA.9010402@boundarydevices.com> <BANLkTimKSfgE7SOPVDhvOcDB5ox6uyPc_Q@mail.gmail.com> <4E0CC8FC.9050906@boundarydevices.com> <BANLkTi=TO1gVRz7h-tOH2Cx7yiNVr=enng@mail.gmail.com> <4E0CD5C4.7010702@boundarydevices.com>
In-Reply-To: <4E0CD5C4.7010702@boundarydevices.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/30/2011 1:00 PM, Troy Kisky wrote:
> On 6/30/2011 12:20 PM, Krakowski, Oz wrote:
>> Troy,
>> On Thu, Jun 30, 2011 at 2:05 PM, Troy Kisky
>> <troy.kisky@boundarydevices.com> wrote:
>>> On 6/29/2011 11:24 PM, mangesh gadre wrote:
>>>> Hi,
>>>>
>>>> Please check if your wifi enable pin is in right state. secondly check if
>>>> regulator section of your chip is actually powering up wifi internal core .
>>>> check your circuit against standard ref circuit.
>>>> I have seen similar issue and there was some resistor missing in feedback
>>>> path of volatge regulator output path from chip. Most probably wifi section
>>>> of your chip is not powered up.
>>>
>>> I think the problem is solved, but can you point me to a "standard ref
>>> circuit" for TiWiR2. Maybe, I can avoid future problems.
>>
>> For the benefit of everyone, can you share what was the issue?
>>
>> Thanks,
>> Oz.
> 

Another problem was that gpio interrupts were not working on mx53
platforms on 3.0-rc4. I just submitted a patch.

Thanks
Troy
