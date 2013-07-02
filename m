Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3681 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab3GBVRf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 17:17:35 -0400
Message-ID: <51D33EC2.1090108@broadcom.com> (sfid-20130702_231739_053443_4C3CD726)
Date: Tue, 2 Jul 2013 22:57:38 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Greg KH" <gregkh@linuxfoundation.org>
cc: stable@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] brcmfmac: Turn off ARP offloading when configured
 for AP.
References: <1370508957-12709-1-git-send-email-arend@broadcom.com>
 <51C15D4D.6040009@broadcom.com> <20130619141920.GB7395@kroah.com>
 <51C1D392.8060705@broadcom.com> <20130619165217.GC5419@kroah.com>
In-Reply-To: <20130619165217.GC5419@kroah.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2013 06:52 PM, Greg KH wrote:
> On Wed, Jun 19, 2013 at 05:51:46PM +0200, Arend van Spriel wrote:
>> On 06/19/2013 04:19 PM, Greg KH wrote:
>>> On Wed, Jun 19, 2013 at 09:27:09AM +0200, Arend van Spriel wrote:
>>>> On 06/06/2013 10:55 AM, Arend van Spriel wrote:
>>>>> From: Hante Meuleman <meuleman@broadcom.com>
>>>>
>>>> Hi Greg,
>>>>
>>>> I noticed your review announcement for v3.9.7 and did not see the
>>>> change below. I sent it to stable because the original upstream
>>>> commit did not apply. Did I miss some step in the process?
>>>
>>> Ah, somehow I missed your patch, sorry about that, I do have it in my
>>> mbox.  What kernel tree(s) do you want it to be applied to?  I'll pick
>>> it up in my next round of releases.
>>
>> Thanks, Greg
>>
>> I backported it for the 3.9 tree. It does not apply to 3.8 so I will
>> have to create another backport if I need it there.
>
> 3.8 is long dead and not maintained by me anymore, but thanks.

Hi Greg,

Forgot to ask, but it seems like Canonical is maintaining additional 
stable kernel branches. I guess I should contact them for those kernel 
versions (if I care), right?

Regards,
Arend

> Next time you submit stable patches, please let us know somewhere in the
> patch/subject what tree it applies to, that makes our lives much easier,
> otherwise I just guess and ususally get it wrong :)
>
> thanks,
>
> greg k-h
>


