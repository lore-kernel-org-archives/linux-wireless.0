Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:56336 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752926Ab1F3UAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 16:00:20 -0400
Message-ID: <4E0CD5C4.7010702@boundarydevices.com> (sfid-20110630_220024_147853_A0FDC8A1)
Date: Thu, 30 Jun 2011 13:00:04 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
MIME-Version: 1.0
To: "Krakowski, Oz" <ozk@ti.com>
CC: mangesh gadre <mangeshgadre07@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: WL1271: WLAN_IRQ not working
References: <4E0942CA.9010402@boundarydevices.com> <BANLkTimKSfgE7SOPVDhvOcDB5ox6uyPc_Q@mail.gmail.com> <4E0CC8FC.9050906@boundarydevices.com> <BANLkTi=TO1gVRz7h-tOH2Cx7yiNVr=enng@mail.gmail.com>
In-Reply-To: <BANLkTi=TO1gVRz7h-tOH2Cx7yiNVr=enng@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/30/2011 12:20 PM, Krakowski, Oz wrote:
> Troy,
> On Thu, Jun 30, 2011 at 2:05 PM, Troy Kisky
> <troy.kisky@boundarydevices.com> wrote:
>> On 6/29/2011 11:24 PM, mangesh gadre wrote:
>>> Hi,
>>>
>>> Please check if your wifi enable pin is in right state. secondly check if
>>> regulator section of your chip is actually powering up wifi internal core .
>>> check your circuit against standard ref circuit.
>>> I have seen similar issue and there was some resistor missing in feedback
>>> path of volatge regulator output path from chip. Most probably wifi section
>>> of your chip is not powered up.
>>
>> I think the problem is solved, but can you point me to a "standard ref
>> circuit" for TiWiR2. Maybe, I can avoid future problems.
> 
> For the benefit of everyone, can you share what was the issue?
> 
> Thanks,
> Oz.

I think missing level shifters were the problem. It will be a little
while before I can test revised hardware though.

Troy
