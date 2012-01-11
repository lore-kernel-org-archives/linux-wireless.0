Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:59112 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756590Ab2AKLkz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 06:40:55 -0500
Received: by obbup16 with SMTP id up16so732459obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 03:40:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
Date: Wed, 11 Jan 2012 12:40:54 +0100
Message-ID: <CAC9WiBhVWvvN-yqoYvBoD1uUi0P5e2cBu68Mva99wVxr7W0ibg@mail.gmail.com> (sfid-20120111_124058_720432_C3D8162E)
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
From: Francis Moreau <francis.moro@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Sep 8, 2011 at 10:46 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello,
>
> I have a question regarding the following patch:
> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/75638
>
> The commit message says:
>
>   brcmsmac doesn't yet use bcma, but both drivers attempt to claim the same
>   device.  For now, turn of brcmsmac if bcma is enabled.
>
> I think it's not quite complete:  both driver claim the same devices
> (actually that's not entirely true since b43/bcma can drive on more
> card) but in the case of b43/bcma not all cards are actually working.
> For example I'm using BCM4313 card with an unsupported phy
> (B43_PHYTYPE_LCN) so it's basically not supported by b43/bcma.
>
> So I'm wondering if b43/bcma should be simply disabled until it got
> the same level of support as brcmsmac ?

This has finally been merged and is part of the 3.2 release.

So now distros don't ship the brcmsmac driver anymore which is
basically the only driver which can handle my card.

did you really intend to do that ?

Thanks
-- 
Francis
