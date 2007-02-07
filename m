Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:34045 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965613AbXBGBI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 20:08:29 -0500
Message-ID: <45C9268B.3040408@lwfinger.net>
Date: Tue, 06 Feb 2007 19:08:27 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: bcm43xx-dev@lists.berlios.de, Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: RFT bcm43xx: Really _GOOD_ news
References: <45C8E64B.1050605@lwfinger.net> <1170800330.2613.10.camel@dv> <200702062327.17401.rjw@sisk.pl>
In-Reply-To: <200702062327.17401.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafael J. Wysocki wrote:
> On Tuesday, 6 February 2007 23:18, Pavel Roskin wrote:
>> On Tue, 2007-02-06 at 14:34 -0600, Larry Finger wrote:
>>> I have really _GOOD_ news!!!!! While reviewing the latest changes in the V4 specs, I found an
>>> interchange of the PHY version and PHY revision fields, relative to the current V3 specs. Of the
>>> three cards that I have, the 4306 had the same value for the PHY version and revision. In addition,
>>> it was the only card of the 3 thaw would work at 11Mbs. A light went on!
>>>
>>> After installing the patch listed below, both my 4318 and my 4311 will now run at 11Mbs. From tests
>>> with iperf, I now get rates of 6.1 - 6.5 Mbs from all three.
>> I'm getting a sustained 1.7 megabytes per second over FTP with 4312
>> (PCIe card in Dell Latitude).  The connection to a 802.11g AP was
>> established instantaneously.
>>
>> I have never had much success with the softmac driver at all.  Now it's
>> working better than the d80211 driver, with waits for minutes before it
>> starts talking to the same 802.11g AP.
>>
>> I think it's a 2.6.20.1 material, considering its gain/changes ratio.
>> I'm actually going to compile this kernel without debug and keep it as a
>> "production" kernel.
>>
>> Congratulations and many many thanks!
> 
> I can confirm the driver works great with the patch!
> 
> Many thanks, Larry!

You are all very welcome.

Now that others have verified that the patch makes their system work, I will be submitting it for
wireless-2.6 that will get it into 2.6.21. I will also submit it to stable so it should be included
in 2.6.20.1 and 2.6.19.4.

Larry
