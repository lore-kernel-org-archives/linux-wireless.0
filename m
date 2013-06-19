Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3292 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934714Ab3FSPv6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 11:51:58 -0400
Message-ID: <51C1D392.8060705@broadcom.com> (sfid-20130619_175202_147889_2DA6D3D5)
Date: Wed, 19 Jun 2013 17:51:46 +0200
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
In-Reply-To: <20130619141920.GB7395@kroah.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2013 04:19 PM, Greg KH wrote:
> On Wed, Jun 19, 2013 at 09:27:09AM +0200, Arend van Spriel wrote:
>> On 06/06/2013 10:55 AM, Arend van Spriel wrote:
>>> From: Hante Meuleman <meuleman@broadcom.com>
>>
>> Hi Greg,
>>
>> I noticed your review announcement for v3.9.7 and did not see the
>> change below. I sent it to stable because the original upstream
>> commit did not apply. Did I miss some step in the process?
>
> Ah, somehow I missed your patch, sorry about that, I do have it in my
> mbox.  What kernel tree(s) do you want it to be applied to?  I'll pick
> it up in my next round of releases.

Thanks, Greg

I backported it for the 3.9 tree. It does not apply to 3.8 so I will 
have to create another backport if I need it there.

Regards,
Arend


