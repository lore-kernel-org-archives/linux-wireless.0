Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:49473 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227Ab1F3T3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 15:29:09 -0400
Received: by mail-ww0-f49.google.com with SMTP id 22so2086296wwf.30
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 12:29:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E0CC8FC.9050906@boundarydevices.com>
References: <4E0942CA.9010402@boundarydevices.com> <BANLkTimKSfgE7SOPVDhvOcDB5ox6uyPc_Q@mail.gmail.com>
 <4E0CC8FC.9050906@boundarydevices.com>
From: "Krakowski, Oz" <ozk@ti.com>
Date: Thu, 30 Jun 2011 14:20:49 -0500
Message-ID: <BANLkTi=TO1gVRz7h-tOH2Cx7yiNVr=enng@mail.gmail.com> (sfid-20110630_212914_916507_913F8BF1)
Subject: Re: WL1271: WLAN_IRQ not working
To: Troy Kisky <troy.kisky@boundarydevices.com>
Cc: mangesh gadre <mangeshgadre07@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Troy,
On Thu, Jun 30, 2011 at 2:05 PM, Troy Kisky
<troy.kisky@boundarydevices.com> wrote:
> On 6/29/2011 11:24 PM, mangesh gadre wrote:
>> Hi,
>>
>> Please check if your wifi enable pin is in right state. secondly check if
>> regulator section of your chip is actually powering up wifi internal core .
>> check your circuit against standard ref circuit.
>> I have seen similar issue and there was some resistor missing in feedback
>> path of volatge regulator output path from chip. Most probably wifi section
>> of your chip is not powered up.
>
> I think the problem is solved, but can you point me to a "standard ref
> circuit" for TiWiR2. Maybe, I can avoid future problems.

For the benefit of everyone, can you share what was the issue?

Thanks,
Oz.
