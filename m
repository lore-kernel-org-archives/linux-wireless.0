Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox2.netikka.net ([213.250.81.203]:43845 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701AbZGNWpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 18:45:03 -0400
Message-ID: <4A5D0A7F.5090108@mandriva.org>
Date: Wed, 15 Jul 2009 01:45:19 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Thomas Backlund <tmb@mandriva.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: unable to bring up iwlagn wireless after update from 2.6.29.6
 to 2.6.31-rc3
References: <4A5D0374.5040702@mandriva.org> <1247611024.1796.21.camel@johannes.local>
In-Reply-To: <1247611024.1796.21.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg skrev:
> On Wed, 2009-07-15 at 01:15 +0300, Thomas Backlund wrote:
>> Hi,
>> (please cc me on replies)
>>
>> before I start to try and figure this out, I thought of asking here if 
>> it rings any bells...
>>
>> Distribution: Mandriva Cooker
>> Arch: x86_64.
>>
>> NIC: 04:00.0 Network controller [0280]: Intel Corporation PRO/Wireless 
>> 4965 AG or AGN [Kedron] Network Connection [8086:4229] (rev 61)
>>
>> ucode version: 228.61.2.24
>>
>> wpa_supplicant version: 0.6.9
>> crda version: 1.1.0
>> wireless-regdb version: 2009.04.17
>>
>> Running a 2.6.29.6 based kernel works with iwlagn
>> Running a 2.6.30.1 based kernel works with iwlagn
>>
>> Running a 2.6.31-rc3 based kernel gets me this:
>>
>> --- cut ---
>> Bringing up interface wlan0:  RTNETLINK answers: Unknown error 132
>> RTNETLINK answers: Unknown error 132
> 
> press your rfkill button.

I wish it was that simple :-(

I already tried it, but it does not help...
I get no reaction what so ever from pressing it...

The laptop is an Acer 5720G if that makes any difference...

Could it be that rfkill has been broken for my laptop ?

And why should I need to press rfkill now, when I didn't before ?
Has some kernel defaults changed since 2.6.30 series ?

--
Thomas
