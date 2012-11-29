Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.legal.de ([46.38.240.131]:60997 "EHLO mail.legal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab2K2MdI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 07:33:08 -0500
Message-ID: <50B755FC.4030100@schwarze-allianz.de> (sfid-20121129_133313_542161_DBBD4600)
Date: Thu, 29 Nov 2012 13:33:00 +0100
From: Jens Kapitza <j.kapitza@schwarze-allianz.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Subject: Re: iwlwifi hibernate / suspend issue
References: <50B61C71.6060007@schwarze-allianz.de> (sfid-20121128_152227_935873_AFE02FFF) <1354113010.9345.27.camel@jlt4.sipsolutions.net> <50B62254.9070700@schwarze-allianz.de> <1354113722.9345.28.camel@jlt4.sipsolutions.net> <50B62BEB.6020109@schwarze-allianz.de> <1354120982.9345.35.camel@jlt4.sipsolutions.net> (sfid-20121128_174246_886056_FD8C7512) <1354126096.9345.45.camel@jlt4.sipsolutions.net>
In-Reply-To: <1354126096.9345.45.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 28.11.2012 19:08, schrieb Johannes Berg:
> On Wed, 2012-11-28 at 17:43 +0100, Johannes Berg wrote:
>> On Wed, 2012-11-28 at 16:21 +0100, Jens Kapitza wrote:
>>>> just enter "dmesg" and pastebin the result somewhere
>>> this line seems to be wrong
>>>
>>>    [ 4650.687346] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
>> Well, it's not necessarily wrong, it indicates that the device read that
>> the rfkill line was pulled low ("rf should be off").
>>
>> You said reloading the module fixes this
> So it doesn't, and if you need to restart the computer that indicates a
> problem with the ACPI support code, but I don't know if you have that
> loaded at all.
I'll move to acpi list (will search it later)
I'm using uefi and acpi is compied and loaded
>
> So yeah, you were right when you said it's related to the BIOS, I just
> thought you said reloading the module fixed it which I thought was very
> strange. Since it doesn't, it's just the BIOS/whatever pulling the line
> low and there's nothing the wifi driver can do about that, we can't even
> ignore that.
>
> johannes
>
thanks to clearify my problem


