Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:47433
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbZFIJVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 05:21:11 -0400
Date: Tue, 9 Jun 2009 18:21:12 +0900
From: Mattia Dongili <malattia@linux.it>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] sony-laptop: no need to unblock rfkill on load
Message-ID: <20090609092112.GE7682@kamineko.org>
References: <4A2CE86F.9040209@tuffmail.co.uk> <1244457418.18863.8.camel@johannes.local> <20090608224915.GA4583@kamineko.org> <4A2E1DE3.4020509@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A2E1DE3.4020509@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 09, 2009 at 09:31:31AM +0100, Alan Jenkins wrote:
> Mattia Dongili wrote:
>> On Mon, Jun 08, 2009 at 12:36:58PM +0200, Johannes Berg wrote:
>>   
>>> On Mon, 2009-06-08 at 11:31 +0100, Alan Jenkins wrote:
>>>     
>>>> The re-written rfkill core ensures rfkill devices are initialized to
>>>> the system default state.  The core calls set_block after registration
>>>> so the driver shouldn't need to.
>>>>
>>>> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
>>>>       
>>> Good catch, thanks.
>>>     
>>
>> Just to confirm, is this patch going to sit in the wireless-testing tree
>> and you will submit it for inclusion together with the rfkill work
>> right?
>>   
>
> Yes.  I probably didn't need to ping you at this point.
>
> It just bothered me because I was effectively reverting a recent commit.  
> I figuired I should let you know.  In case it didn't work, when it was 
> merged you'd know why I did it and who to blame.  But there is always Git 
> history for that :-).

Errm... now that I look at that patch more closely, the code you're
modifying is not upstream either.
Anyway thanks for the ping, I'll take a look at what's going on in the
wireless-testing tree ;)

cheers
-- 
mattia
:wq!
