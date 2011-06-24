Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4490 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab1FXWjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 18:39:12 -0400
Message-ID: <4E0511FE.3070701@broadcom.com> (sfid-20110625_003917_403249_4DB82ADC)
Date: Fri, 24 Jun 2011 15:38:54 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <error27@gmail.com>
cc: "Henry Ptasinski" <henryp@broadcom.com>,
	"julie Sullivan" <kernelmail.jms@gmail.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH 00/21] staging: brcm80211: code cleanup and fullmac
 bugfix
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
 <20110609185420.GK4069@shale.localdomain>
 <BANLkTi=FuX0H3UOi6M_LL5t5hdDen77WcQ@mail.gmail.com>
 <4DF1D0A5.8080300@broadcom.com>
 <BANLkTi=bVse-E2Gc+ArN8AyS3JwZNAPzmA@mail.gmail.com>
 <20110612190045.GB3583@shale.localdomain>
 <20110614175035.GE9280@broadcom.com>
In-Reply-To: <20110614175035.GE9280@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/14/2011 10:50 AM, Henry Ptasinski wrote:
> On Sun, Jun 12, 2011 at 12:00:45PM -0700, Dan Carpenter wrote:
>    
>> On Sun, Jun 12, 2011 at 07:23:27PM +0100, julie Sullivan wrote:
>>      
>>>> I am using GregKH's staging-next repo:
>>>> git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git
>>>>
>>>>          
>>>        
>>>> The patch applies on top of 5ad7b85b90e30eb5af4fbf6ce21907a2bd8934df.
>>>>
>>>> Bye, Roland.
>>>>
>>>>          
>>> OK, this compiles fine on x86-64/SMP. It's probably not interesting
>>> but there are just a few warnings:
>>>
>>>        
>> Yeah.  The driver only works under 32 bit.  This is listed in the
>> TODO file as something to fix before it leaves staging.
>>
>>      
> At the moment, we haven't really seen any interest in 64-bit support with sdio
> (almost all actual usage is 32-bit ARM as far as I can tell), but it will
> definitely get more relevant when we add USB support to brcmfmac.  We'll work
> on getting it up and running, but any help would be appreciated.
>
> Is it safe to assume the related modules (mmc.ko, etc) work on 64-bit?
>
> - Henry

I've verified that the brcmfmac driver works on 64-bit x86 kernels.
There are a few compiler warnings that we'll clean up.

- Henry

