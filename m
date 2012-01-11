Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:54160 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754193Ab2AKOao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 09:30:44 -0500
Received: by obbup16 with SMTP id up16so916766obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 06:30:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F0D9BF8.7020001@broadcom.com>
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
	<CAC9WiBhVWvvN-yqoYvBoD1uUi0P5e2cBu68Mva99wVxr7W0ibg@mail.gmail.com>
	<4F0D7F6B.5000601@broadcom.com>
	<CAC9WiBgp02u90rJNC64kKU8GN7jcP_YOSRXSBbR83kHvf3CneQ@mail.gmail.com>
	<4F0D9BF8.7020001@broadcom.com>
Date: Wed, 11 Jan 2012 15:30:43 +0100
Message-ID: <CAC9WiBiAhpyiWjA6XqhtX_M=wn0ipuo3-wzzMpDyxUM77kZX7A@mail.gmail.com> (sfid-20120111_153047_601097_6D308361)
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
From: Francis Moreau <francis.moro@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 11, 2012 at 3:26 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 01/11/2012 02:13 PM, Francis Moreau wrote:
>> On Wed, Jan 11, 2012 at 1:24 PM, Arend van Spriel <arend@broadcom.com> wrote:
>>> On 01/11/2012 12:40 PM, Francis Moreau wrote:
>>>> Hi,
>>>>
>>>> This has finally been merged and is part of the 3.2 release.
>>>>
>>>> So now distros don't ship the brcmsmac driver anymore which is
>>>> basically the only driver which can handle my card.
>>>
>>> I am not sure why you come to that conclusion,
>>
>> I checked on both OpenSuse and Mandriva, and they both have CONFIG_BCMA=m.
>>
>>> For kernel v3.3 the brcmsmac driver will be using bcma.
>>
>> Great.
>>
>> But v3.2...
>>
>
> Given the configuration BCMA=m I agree that brcmsmac is probably not in
> the distro in binary form. However, you can probably install the kernel
> source package and rebuilt the kernel with BCMA=n and BRCMSMAC=m.

Sure but it's not really nice for all users in the same case,
specially since we could have done otherwise that would have make
happy the poor user I am until the b43 has support for bcma (next
release if I understood correctly).

Users are unlikely to know/will to recompile his kernel, I think.
-- 
Francis
