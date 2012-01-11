Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2942 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932786Ab2AKO0L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 09:26:11 -0500
Message-ID: <4F0D9BF8.7020001@broadcom.com> (sfid-20120111_152615_195520_DF809D40)
Date: Wed, 11 Jan 2012 15:26:00 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Francis Moreau" <francis.moro@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>
Subject: Re: About the patch:
 "staging: brcm80211: only enable brcmsmac if bcma is not set"
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
 <CAC9WiBhVWvvN-yqoYvBoD1uUi0P5e2cBu68Mva99wVxr7W0ibg@mail.gmail.com>
 <4F0D7F6B.5000601@broadcom.com>
 <CAC9WiBgp02u90rJNC64kKU8GN7jcP_YOSRXSBbR83kHvf3CneQ@mail.gmail.com>
In-Reply-To: <CAC9WiBgp02u90rJNC64kKU8GN7jcP_YOSRXSBbR83kHvf3CneQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2012 02:13 PM, Francis Moreau wrote:
> On Wed, Jan 11, 2012 at 1:24 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 01/11/2012 12:40 PM, Francis Moreau wrote:
>>> Hi,
>>>
>>> This has finally been merged and is part of the 3.2 release.
>>>
>>> So now distros don't ship the brcmsmac driver anymore which is
>>> basically the only driver which can handle my card.
>>
>> I am not sure why you come to that conclusion,
> 
> I checked on both OpenSuse and Mandriva, and they both have CONFIG_BCMA=m.
> 
>> For kernel v3.3 the brcmsmac driver will be using bcma.
> 
> Great.
> 
> But v3.2...
> 

Given the configuration BCMA=m I agree that brcmsmac is probably not in
the distro in binary form. However, you can probably install the kernel
source package and rebuilt the kernel with BCMA=n and BRCMSMAC=m.

Gr. AvS

