Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4141 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab2DPIvP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 04:51:15 -0400
Message-ID: <4F8BDD79.6030008@broadcom.com> (sfid-20120416_105118_487304_039AA924)
Date: Mon, 16 Apr 2012 10:51:05 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Greg KH" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/9] brcm80211: minor bug fixes for broadcom driver
References: <1334137971-3972-1-git-send-email-arend@broadcom.com>
 <20120413175717.GD2616@tuxdriver.com>
In-Reply-To: <20120413175717.GD2616@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/13/2012 07:57 PM, John W. Linville wrote:
> On Wed, Apr 11, 2012 at 11:52:42AM +0200, Arend van Spriel wrote:
>
> In general, when mixing fixes and features/updates into a single
> series then the fixes should come at the beginning of the series.
> This helps to avoid dependencies on non-fix patches.
>
> I'll try to apply patch 9 to the wireless tree, and if that works I
> won't complain about it... :-)
>
> John

Like mentioned on collaboration summit, we may need a bit more education 
on how to deal with stable fixes. I tagged the patch with cc to stable, 
but not sure if that is the correct way to do it. The stable rules are 
written in a generic way so I want know how the picture looks like when 
moving patches upstream via a maintainer tree.

So here is my understanding:

1. submit patch without CC'ing stable against your wireless tree.
2. patch moves upstream to Dave's net tree.
3. patch moves further upstream to Linus' tree.
4. submit patch to stable with upstream commit id.

Is adding the CC to stable in step 1. a shortcut or is step 4. still 
necessary in that case?

Gr. AvS

