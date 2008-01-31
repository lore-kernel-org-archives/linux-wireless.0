Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38766 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYAaGJ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 01:09:29 -0500
Message-ID: <47A16611.3000602@garzik.org> (sfid-20080131_060934_677584_9388EB79)
Date: Thu, 31 Jan 2008 01:09:21 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: dlezcano@fr.ibm.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: net-2.6.25 is no more...
References: <20080129.212216.186173371.davem@davemloft.net>	<47A03D4D.5090301@fr.ibm.com> <20080130.054807.182676684.davem@davemloft.net>
In-Reply-To: <20080130.054807.182676684.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:
> From: Daniel Lezcano <dlezcano@fr.ibm.com>
> Date: Wed, 30 Jan 2008 10:03:09 +0100
> 
>> David Miller wrote:
>>> Now that the bulk has been merged over and we are
>>> actively working alongside Linus's tree I have moved
>>> all current patch applying to net-2.6 instead of net-2.6.25,
>>> so the current tree to use is:
>>>
>>> 	kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git
>> This tree is for fixes only, right ? or shall we send enhancement 
>> patches to net-2.6 until net-2.6.26 appears ?
> 
> The latter.

So...  what to do about changes which are not bug fixes?  Such changes 
should not go upstream immediately, because that's the standard rule for 
merge windows.

And queueing them on our side just re-creates the same old situation we 
just changed away from, after all.

	Jeff




