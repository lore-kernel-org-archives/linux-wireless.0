Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:64287 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3GCEyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 00:54:05 -0400
MIME-Version: 1.0
In-Reply-To: <51D33EC2.1090108@broadcom.com>
References: <1370508957-12709-1-git-send-email-arend@broadcom.com>
	<51C15D4D.6040009@broadcom.com>
	<20130619141920.GB7395@kroah.com>
	<51C1D392.8060705@broadcom.com>
	<20130619165217.GC5419@kroah.com>
	<51D33EC2.1090108@broadcom.com>
Date: Wed, 3 Jul 2013 06:54:04 +0200
Message-ID: <CACna6rzqjh0uC=qNThA=fsNmbLz+b0NUfkvFSLZ7GhRdGqOYug@mail.gmail.com> (sfid-20130703_065410_553279_BA351436)
Subject: Re: [PATCH] brcmfmac: Turn off ARP offloading when configured for AP.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/7/2 Arend van Spriel <arend@broadcom.com>:
> On 06/19/2013 06:52 PM, Greg KH wrote:
>>
>> On Wed, Jun 19, 2013 at 05:51:46PM +0200, Arend van Spriel wrote:
>>>
>>> On 06/19/2013 04:19 PM, Greg KH wrote:
>>>>
>>>> On Wed, Jun 19, 2013 at 09:27:09AM +0200, Arend van Spriel wrote:
>>>>>
>>>>> On 06/06/2013 10:55 AM, Arend van Spriel wrote:
>>>>>>
>>>>>> From: Hante Meuleman <meuleman@broadcom.com>
>>>>>
>>>>>
>>>>> Hi Greg,
>>>>>
>>>>> I noticed your review announcement for v3.9.7 and did not see the
>>>>> change below. I sent it to stable because the original upstream
>>>>> commit did not apply. Did I miss some step in the process?
>>>>
>>>>
>>>> Ah, somehow I missed your patch, sorry about that, I do have it in my
>>>> mbox.  What kernel tree(s) do you want it to be applied to?  I'll pick
>>>> it up in my next round of releases.
>>>
>>>
>>> Thanks, Greg
>>>
>>> I backported it for the 3.9 tree. It does not apply to 3.8 so I will
>>> have to create another backport if I need it there.
>>
>>
>> 3.8 is long dead and not maintained by me anymore, but thanks.
>
>
> Hi Greg,
>
> Forgot to ask, but it seems like Canonical is maintaining additional stable
> kernel branches. I guess I should contact them for those kernel versions (if
> I care), right?

They track Greg's stables to pick up the patches. Know from my own
experience, I didn't have to ping anyone :)

-- 
Rafał
