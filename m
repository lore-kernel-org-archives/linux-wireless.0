Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33149 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab0GFMF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 08:05:28 -0400
Message-ID: <4C331C06.2040708@candelatech.com>
Date: Tue, 06 Jul 2010 05:05:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanoharan@atheros.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k doesn't clean up virtual wifis on rmmod, and crashes.
References: <4C2ED806.9000105@candelatech.com> <20100703070259.GA15479@vasanth-laptop> <4C2F6681.7070202@candelatech.com> <20100704093535.GE5053@vasanth-laptop> <4C30AFD0.80100@candelatech.com> <4C322B26.7080701@candelatech.com> <20100706083621.GA11134@vmraj-laptop>
In-Reply-To: <20100706083621.GA11134@vmraj-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/06/2010 01:36 AM, Rajkumar Manoharan wrote:
> On Tue, Jul 06, 2010 at 12:27:42AM +0530, Ben Greear wrote:
>> I ran the same test on wireless-testing, and it still crashes.
>>
>> It appears that the patch you sent is already in wireless-testing,
>> so I did not apply it.

> Can you please try this patch?

That patch appears to fix the problem.  I was able to rmmod
ath9k after adding a virtual phy and no crashes.  It used to
immediately crash every time.

I'll do some more testing later today if all goes according to plan.

Thanks!
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
