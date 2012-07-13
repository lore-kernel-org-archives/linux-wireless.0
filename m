Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2988 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab2GMJbQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 05:31:16 -0400
Message-ID: <4FFFEAD3.6070203@broadcom.com> (sfid-20120713_113143_835449_BFC879C3)
Date: Fri, 13 Jul 2012 11:30:59 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: sheerapthinath <sheerapthinath@gmail.com>
cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: BCM4313 injection support
References: <CAJuQfSjWuF=APbRTGbQoBi4fzusd_-CNfBrmS2WOoFWJd1A_hg@mail.gmail.com>
In-Reply-To: <CAJuQfSjWuF=APbRTGbQoBi4fzusd_-CNfBrmS2WOoFWJd1A_hg@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2012 09:37 AM, sheerapthinath wrote:
> Hi linux wireless,
> 
> Is there hardware support for injection in BCM4313 wireless card(PCI
> id:14e4:4727)?
> I only that driver has partial support  without injection. I dunno if
> there is hardware support.
> Can you please let me know the details?

>From the documentation in [1] I see that mac80211 can handle this on a
monitor interface. brcmsmac does support monitoring, but I am not sure
what functionality is needed in the brcmsmac driver for injection. Maybe
Johannes can elaborate.

> I am also planning to buy a wireless card with full injection support
> if BCM4313 is not supported.
> Can you  please suggest me some good cheap wireless card with full
> injection support?
> 
> --
> Regards,
> Sheerapthinath OS
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Gr. AvS

[1] http://linuxwireless.org/en/users/Documentation/packetspammer

