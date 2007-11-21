Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:57204 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210AbXKUVta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 16:49:30 -0500
Message-ID: <4744A7E3.6090105@lwfinger.net> (sfid-20071121_214953_936231_024A7CC7)
Date: Wed, 21 Nov 2007 15:49:23 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Changes to enable BCM4311 rev 02 with wireless core
 revision 13
References: <474487a9.9c54/m97tX72L4+l%Larry.Finger@lwfinger.net> <4744A443.6070808@redhat.com>
In-Reply-To: <4744A443.6070808@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chuck Ebbert wrote:
> On 11/21/2007 02:31 PM, Larry Finger wrote:
>> The BCM94311MCG rev 02 chip has an 802.11 core with revision 13 and
>> has not been supported until now. The changes include the following:
>>
> 
> I put this in a private build of the Fedora 8 kernel in place of the
> the one that was added a few days ago.
> 
> This one works, but I get "PHY transmission error", probably because
> the rfkill switch has disabled it. I see two LED devices and an input
> device were registered but pushing the rfkill switch has no effect.
> Googling doesn't yield any directions for enabling the switch...

I don't think the PHY transmission error is caused by the rfkill switch, but I have no idea where it 
arises. It has been present since I enabled the device with 64-bit DMA.

I have not determined how to get rfkill to react to the LED switch, but now that the BCM4311 rev 02 
card is working, I should have some time to look at it.

Larry
