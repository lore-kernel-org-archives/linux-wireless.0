Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:51814 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbYENR41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 13:56:27 -0400
Received: by py-out-1112.google.com with SMTP id u52so3011pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2008 10:56:26 -0700 (PDT)
Message-ID: <482B27CE.2070700@gmail.com> (sfid-20080514_195631_318256_BF53AB48)
Date: Wed, 14 May 2008 10:56:30 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: Markus Becker <mab@comnets.uni-bremen.de>
CC: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: First patch to mrv8k driver?
References: <482A3961.2010906@gmail.com> <1210739857.2721.51.camel@rd> <Pine.LNX.4.64.0805141506000.24384@bugs.comnets.uni-bremen.de>
In-Reply-To: <Pine.LNX.4.64.0805141506000.24384@bugs.comnets.uni-bremen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Markus Becker wrote:
>
> On Wed, 14 May 2008, Pavel Roskin wrote:
>
>> On Tue, 2008-05-13 at 17:59 -0700, John Daiker wrote:
>>> Hey All,
>>>
>>> My first patch for the mrv8k driver.  My machine locks up when I try to
>>> load a firmware, so I'm not sure if this patch helps anybody or not.
>>
>> I don't see any changes for mrv_reg_read32() claimed in the description.
>
> He is checking the return value to 0x5 instead of 5.
Right... the aim here is for some sort of code consistency.  Makes 
things easier to read, IMHO.
>
>> In fact, I don't see any changes to the code except comments and
>> messages.  I don't see how it can help against lockups, unless you
>> missed some part of the patch.
>
> It does not. But I pushed the comment and indent fixes to mrv8k 
> nevertheless.
Thanks.  I guess I mentioned that to solicit input from others on ideas 
for debugging.
>
>> You may want to spell check your patch, including the description,
>> especially if the patch is fixing spelling mistakes made by others.
Duly noted.  I will keep an keen eye out next time for mistakes. :)
>>
>> -- 
>> Regards,
>> Pavel Roskin
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

