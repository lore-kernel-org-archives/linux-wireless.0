Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2877 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab1F3Vk1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 17:40:27 -0400
Message-ID: <4E0CED43.50305@broadcom.com> (sfid-20110630_234031_186473_2E6F81CF)
Date: Thu, 30 Jun 2011 14:40:19 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <error27@gmail.com>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH 000/119] staging: brcm80211: more code cleanup and
 bug fixed
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <BANLkTikPBWvYiNc1rZEwPJTck=AzUsLncA@mail.gmail.com>
 <4E0CB587.3000209@broadcom.com>
 <20110630183258.GB2544@shale.localdomain>
In-Reply-To: <20110630183258.GB2544@shale.localdomain>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2011 11:32 AM, Dan Carpenter wrote:
> On Thu, Jun 30, 2011 at 10:42:31AM -0700, Henry Ptasinski wrote:
>> On 06/29/2011 11:29 PM, Rafał Miłecki wrote:
>>> 2011/6/30 Franky Lin<frankyl@broadcom.com>:
>>>> Most of these patches are brcmfmac cleanup.
>>>
>>>
>>> Hm, interesting improvement in your "Release early, release often" strategy.
>>>
>>
>> Yea, we were waiting for the previous series to get applied.  Not
>> sure how to make this work better.  Any process suggestions would be
>> appreciated.
>
> Maintain your own git tree.  Post patches in bunches.  If no one
> comments on them within 3 days then probably you can assume they
> are going to be merged.  In the [0 / X] patch say something like:
>
>    Fixes blah blah blah.
>
>    Applies to linux-next with the following patch sets applied:
>    Message-ID:<1309391303-22741-1-git-send-email-frankyl@broadcom.com>
>    Message-ID:<8888888888-88888-1-git-send-email-frankyl@broadcom.com>
>    Or you can get the patches from git://whatever branch.
>
> regards,
> dan carpenter
>

So there are two suggestions here:

1. post patches in smaller bunches, and include dependency info in the 
0/X patch.  Presumably, if one of the dependencies is dropped, then 
people will know to drop this series as well, and we would have to 
repost everything that was dropped once we fix the identified issues.

2. maintain a public git tree that people can pull from.  If we do (1), 
is this needed and/or still useful?  Do community folks that want to 
contribute changes send them to us or Greg/John/whoever is upstream? 
Pros/cons?  Anybody have tips on workflow (my git mastery is still quite 
weak)?

Thanks,
- Henry


