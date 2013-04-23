Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4904 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab3DWVKg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 17:10:36 -0400
Message-ID: <5176F8C2.7050502@broadcom.com> (sfid-20130423_235840_186706_56866203)
Date: Tue, 23 Apr 2013 23:10:26 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Bruno Randolf" <br1@einfach.org>
cc: linux-wireless@vger.kernel.org, frankyl@broadcom.com,
	meuleman@broadcom.com, brudley@broadcom.com,
	brcm80211-dev-list@broadcom.com
Subject: Re: Broadcom brcmfmac vs bcmdhd on Android
References: <5176ABB1.2070506@einfach.org>
In-Reply-To: <5176ABB1.2070506@einfach.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/23/2013 05:41 PM, Bruno Randolf wrote:
> Hello!
>
> I know this is the Linux kernel wireless list, and not Android, but due
> to the lack of better places, I'm going to ask here...

The lines are less drawn than they used to be (at least for me).

> I am trying to make IBSS mode work on Android. As I'm finding problems
> with "bcmdhd", I am wondering if using the "brcmfmac" under Android
> would be the better way to go?

I am working mainly on brcmfmac. IBSS should work, but reading the 
commit message of your patch I guess it may be a firmware issue so using 
brcmfmac will not make a difference.

> I succeeded to compile brcmfmac from recent compat-drivers against the
> "tuna" (Galaxy Nexus) kernel, the modules load, but no device is
> recognized. Has anyone succeeded doing this? Is there any chance it can
> work?

That is how we did it and with success. What do you mean by 'no device 
is recognized'? Do you have any traces to look at?

> Also I'm wondering what is the relation between the "bcmdhd" driver on
> Android and "brcmfmac" in the standard Linux kernel. Is there any
> official maintainer of "bcmdhd", any place where to submit patches? Will
> "bcmdhd" and "brcmfmac" merge eventually?

bcmdhd is what broadcom open-sourced for android. Separately, we started 
working on brcmfmac for the mainline linux kernel. Both drivers come 
from the same proprietary driver. The goal is to have brcmfmac work on 
Android as well and we have most features on board for that.

Regards


