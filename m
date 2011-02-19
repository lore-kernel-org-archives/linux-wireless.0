Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55626 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab1BSAWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 19:22:13 -0500
Received: by gyh20 with SMTP id 20so211486gyh.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 16:22:12 -0800 (PST)
Message-ID: <4D5F0D2D.8050908@lwfinger.net>
Date: Fri, 18 Feb 2011 18:22:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: George Kashperko <george@znau.edu.ua>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	=?ISO-8859-1?Q?Micha?= =?ISO-8859-1?Q?el_B=FCsch?= <mb@bu3sch.de>
Subject: Re: [RFC] AI support (13/14 ssb add AI support)
References: <1297958316.5623.27.camel@dev.znau.edu.ua>	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>	 <1297981882.23381.38.camel@dev.znau.edu.ua>	 (sfid-20110217_233956_707110_FFFFFFFFBE33FFA6)  <1298069145.23801.29.camel@maggie>	 <1298070443.25739.23.camel@dev.znau.edu.ua>	 (sfid-20110219_001605_010946_FFFFFFFFA70C4DCA) <1298071637.23801.40.camel@maggie>	 <4D5F04C0.4080707@lwfinger.net> <1298072855.25739.55.camel@dev.znau.edu.ua>	 <4D5F0990.2060004@lwfinger.net> <1298074131.25739.65.camel@dev.znau.edu.ua>
In-Reply-To: <1298074131.25739.65.camel@dev.znau.edu.ua>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2011 06:08 PM, George Kashperko wrote:
> Hi,
>
>> On 02/18/2011 05:47 PM, George Kashperko wrote:
>>> Hi,
>>>
>>>> I don't want to get involved in the debate over abstraction, but FWIW, the
>>>> patchset does work for PCI-based SSB devices.
>>>>
>>>> Larry
>>>>
>>> Could you please let me know if you tried last code I've posted, as my
>>> original RFC was indeed embeddables' targeted and won't work for
>>> SSB-over-PCI.
>>> Last code I've posted I've tested on SSB over PCIE host and it was
>>> pretty much working.
>>
>> I tested the 14 patches you posted on 2/17/2011 that arrived about 10:20 UTC.
>>
>> Larry
>>
> Ohh, I skrewed again -.-
> Donno how but I decided It didn't work for you. I'm too much sleepy, but
> can't go sleep till coffee let me off. Sorry.

The first set of patches you posed didn't build due to the MIPS problem, but the 
second set built and worked.

Larry
