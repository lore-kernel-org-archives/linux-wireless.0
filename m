Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1734 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab1JLPIa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 11:08:30 -0400
Message-ID: <4E95AD66.1020002@broadcom.com> (sfid-20111012_170844_617830_0D02E944)
Date: Wed, 12 Oct 2011 17:08:22 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Greg KH" <gregkh@suse.de>
cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] staging: brcm80211: remove brcm80211 driver from
 the staging tree
References: <4E95A1D1.8010602@broadcom.com>
 <20111012143600.GA17938@suse.de>
In-Reply-To: <20111012143600.GA17938@suse.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2011 04:36 PM, Greg KH wrote:
> On Wed, Oct 12, 2011 at 04:18:57PM +0200, Arend van Spriel wrote:
>> Hi Greg,
>>
>> John recommended to do the delete through your staging tree. Thanks for
>> the ride. It has been a learning experience for all of us here. Apart
>> from the significant cleanup (which needs ongoing work for sure) it took
>> some time to find the right way of working in coordinating our changes
>> with community patches.
>>
>> The removal patch was just as big as the mainline patch so it has been
>> uploaded to linuxwireless.org:
>>
>> http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=view&target=0001-staging-brcm80211-remove-brcm80211-driver-from-the-s.patch
> 
> So I'm taking it that the driver is now in the wireless-next tree?
> That's great, I'll queue the patch up later today.

It is. From the day I sent the mainline patch for wireless-next we have
been staring at our inbox for the green light :-D

> And thanks so much for working with us, I know it can be hard at times,
> but I hope you will agree that the end result is much better than what
> we started out with.
> 
> greg k-h
> 

Yep. We got rid of a lot of redundant code that was not needed in the
mac80211 framework and the different level of abstractions. The are
still i's to dot and features to add.

Thanks again.

Gr. AvS

