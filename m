Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hmm.wantstofly.org ([138.201.34.84]:54596 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbcFUILL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 04:11:11 -0400
Date: Tue, 21 Jun 2016 11:01:23 +0300
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: David Gilman <dgilman@gilslotd.com>
Cc: linux-wireless@vger.kernel.org,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: Troubleshooting mwl8k driver issue
Message-ID: <20160621080123.GV20238@wantstofly.org> (sfid-20160621_101140_704057_DDD49EB1)
References: <20160604035452.GA5925@dar.local>
 <20160606065146.GK8402@wantstofly.org>
 <20160610040247.GA16190@dar.local>
 <20160617194303.GA33130@dar.local>
 <20160618084828.GN20238@wantstofly.org>
 <20160621003630.GA39401@dar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160621003630.GA39401@dar.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 20, 2016 at 07:36:30PM -0500, David Gilman wrote:

> > Nothing in here seems particularly bad.  So whatever the problem is,
> > I don't think it can be diagnosed from these messages alone.
> > 
> > I went back to the email thread, and it seems that the problem is that
> > you're trying to run the card in AP mode but no traffic is making it
> > through?  Is AP association working at all, or is that failing too?
> 
> The mwl8k is in AP mode and it gets associated just fine.  It'll work
> for five or so minutes and then you'll get the disconnect and the log
> messages in the earlier emails.  And it only happens with one of my
> wireless devices - the other one will browse all day with a stable
> connection to the mwl8k router.
> 
> Back in the OpenWRT issue a few more people have stuck their heads in
> to say they're also seeing the same issue.
> 
> https://dev.openwrt.org/ticket/21284

The only thing the log tells me is that this disconnect happens
voluntarily, so I see nothing wrong from just those log messages.
Can you run a sniffer to see what happens on the air when this
disconnect occurs, or increase hostapd verbosity/debugging somehow?
