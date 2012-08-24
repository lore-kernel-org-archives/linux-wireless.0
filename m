Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4892 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759301Ab2HXK7h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 06:59:37 -0400
Message-ID: <50375E8F.6010302@broadcom.com> (sfid-20120824_125955_140923_C44D3E33)
Date: Fri, 24 Aug 2012 12:59:27 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Sebastian Poehn" <sebastian.poehn@googlemail.com>
cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [BUG] brcmsmac: Invalid killswitch handling
References: <1345798314.1478.12.camel@localhost.localdomain>
In-Reply-To: <1345798314.1478.12.camel@localhost.localdomain>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2012 10:51 AM, Sebastian Poehn wrote:
> I had a discussion with Matthew Garrett about handling of a wifi
> killswitch on a Dell laptop.
>
> Some (rfkill) code was removed from platform/dell-laptop. On my machine
> a bug now occurs which is caused by brcmsmac in the view of Matthew.
>
> So is this a bug, or do you have no killsitch handling, so far?

brcmsmac handled the rfkill switch properly so this would be a 
regression. I also have Dell laptops here with a physical rfkill switch. 
What rfkill switch do you have?

Anyway, I will test over here on my hardware as this regression has been 
flagged internally here as well. Would you be willing to test a fix on 
your system when I have one?

Gr. AvS

