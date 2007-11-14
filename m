Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4791 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760196AbXKNPbN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 10:31:13 -0500
Date: Wed, 14 Nov 2007 10:30:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Henning Rogge <rogge@fgan.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Virtual wireless network card for mac80211
Message-ID: <20071114153041.GB6226@tuxdriver.com> (sfid-20071114_153159_820820_5667C5FA)
References: <200711141316.50393.rogge@fgan.de> <20071114150839.GA6226@tuxdriver.com> <200711141620.15821.rogge@fgan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200711141620.15821.rogge@fgan.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 14, 2007 at 04:20:15PM +0100, Henning Rogge wrote:
> Am Mittwoch 14 November 2007 16:08:39 schrieben Sie:

> > What is the situation that makes this interesting to you?

> I'm not interested in having a binary driver but in simulation of mobile 
> networks with virtual machines. By placing a virtual driver into the mac80211 
> layer the sollution would be totally transparent for the clients, even for 
> applications with Radiotap headers and Libpcap.
> A central server would be connected to the userspace parts of the virtual 
> driver and simulate connections between the VMs.

Even better -- a completely legitimate use for such a feature. :-)

Such a driver might also serve as a development tool for the mac80211
stack developers, and as a model for how drivers should behave when
interacting with mac80211.

In fact, I think Johannes Berg submitted this to the Kernel Newbies
project suggestions already:

	http://kernelnewbies.org/KernelProjects/Mac80211TestDriver

So, any aspiring wireless/kernel hackers out there?

John
-- 
John W. Linville
linville@tuxdriver.com
