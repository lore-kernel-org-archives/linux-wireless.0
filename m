Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:35772 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759472AbZFIIaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 04:30:01 -0400
Message-ID: <4A2E1DE3.4020509@tuffmail.co.uk>
Date: Tue, 09 Jun 2009 09:31:31 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Mattia Dongili <malattia@linux.it>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] sony-laptop: no need to unblock rfkill on load
References: <4A2CE86F.9040209@tuffmail.co.uk> <1244457418.18863.8.camel@johannes.local> <20090608224915.GA4583@kamineko.org>
In-Reply-To: <20090608224915.GA4583@kamineko.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mattia Dongili wrote:
> On Mon, Jun 08, 2009 at 12:36:58PM +0200, Johannes Berg wrote:
>   
>> On Mon, 2009-06-08 at 11:31 +0100, Alan Jenkins wrote:
>>     
>>> The re-written rfkill core ensures rfkill devices are initialized to
>>> the system default state.  The core calls set_block after registration
>>> so the driver shouldn't need to.
>>>
>>> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
>>>       
>> Good catch, thanks.
>>     
>
> Just to confirm, is this patch going to sit in the wireless-testing tree
> and you will submit it for inclusion together with the rfkill work
> right?
>   

Yes.  I probably didn't need to ping you at this point.

It just bothered me because I was effectively reverting a recent 
commit.  I figuired I should let you know.  In case it didn't work, when 
it was merged you'd know why I did it and who to blame.  But there is 
always Git history for that :-).

Regards
Alan
