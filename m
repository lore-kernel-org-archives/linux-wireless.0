Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:57761 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbZAWT61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:58:27 -0500
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Message-Id: <4B2A9520-D727-472F-A62A-0DC2E5F3C2B3@ing.unibs.it> (sfid-20090123_205831_681543_2CAD0F97)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
In-Reply-To: <1232732649.7440.42.camel@pc.interlinx.bc.ca>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: integration of opensource firmware with b43 kernel driver
Date: Fri, 23 Jan 2009 20:58:23 +0100
References: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it> <1232732649.7440.42.camel@pc.interlinx.bc.ca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 23, 2009, at 6:44 PM, Brian J. Murrell wrote:

> On Fri, 2009-01-23 at 18:36 +0100, Francesco Gringoli wrote:
>> Hello,
>>
>> we have been testing the firmware for a week now and it seems stable.
>> I personally tested it also on a Linksys WRT54GL and it works both in
>> station and in AP modes.
>
> Did you try pushing it hard?  i.e. doing a nice big bulk transfer
> through it?  Did it reach decent speeds without pegging the CPU with
> softirqs?
>
> Can you give details on which kernel(s) and how you built/configured  
> the
> router firmware(s)?
Well, I just tested a 500Mbytes bulk transfer and I got a mean  
throughput of about 5.5Mbit/s, it was a simple infinite wget loop so  
we can have some slowness due to TCP. However no errors were logged to  
syslog and the AP is still there, it didn't complain about anything.

I built kamikaze yesterday image (r14144), kernel 2.6.25.17, I used  
the AP as a station joined to another AP without encryption.

By the way, we did thousands of tests with x86 and we came to the  
conclusion that there is no performance (throughput) difference if  
compared to the standard proprietary firmware.

Cheers,
-FG
