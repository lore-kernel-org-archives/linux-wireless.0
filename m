Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50668 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1BDVNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 16:13:22 -0500
Cc: trivial@kernel.org, henryp@broadcom.com, gregkh@suse.de,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <95FFFE22-6CF5-4ECF-B2B4-D6835F0F100E@gmail.com>
From: Justin Mattock <justinmattock@gmail.com>
To: Greg KH <greg@kroah.com>
In-Reply-To: <20110204210021.GA15713@kroah.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 6/8]staging: brcm80211i: sbsdio.h: change a typo comamnd to command
Date: Fri, 4 Feb 2011 13:13:17 -0800
References: <1296623248-5399-1-git-send-email-justinmattock@gmail.com> <20110204205919.GA15658@kroah.com> <20110204210021.GA15713@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Feb 4, 2011, at 1:00 PM, Greg KH wrote:

> On Fri, Feb 04, 2011 at 12:59:19PM -0800, Greg KH wrote:
>> On Tue, Feb 01, 2011 at 09:07:28PM -0800, Justin P. Mattock wrote:
>>> The below patch fixes a typo comamnd to command.
>>>
>>> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>>>
>>> ---
>>> drivers/staging/brcm80211/include/sbsdio.h |    2 +-
>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/staging/brcm80211/include/sbsdio.h b/drivers/ 
>>> staging/brcm80211/include/sbsdio.h
>>> index 6afdbbe..c190acb 100644
>>> --- a/drivers/staging/brcm80211/include/sbsdio.h
>>> +++ b/drivers/staging/brcm80211/include/sbsdio.h
>>> @@ -144,7 +144,7 @@
>>> 						 */
>>>
>>> #define SBSDIO_BYTEMODE_DATALEN_MAX	64	/* sdio byte mode: maximum  
>>> length of one
>>> -						 * data comamnd
>>> +						 * data command
>>
>> This patch adds a trailing space, which is not allowed.
>>
>> Please fix this and resend.
>
> Nevermind, I've edited this by hand and fixed it up.
>
> Please be more careful in the future and ALWAYS run your patches  
> through
> scripts/checkpatch.pl to catch these types of things.
>
> thanks,
>
> greg k-h


yep I admit I had forgotten to use that script(was focusing on  
maintainers)..
I will remember that next time..

Thanks..

Justin P. Mattock
