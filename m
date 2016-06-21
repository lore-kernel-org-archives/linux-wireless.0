Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:33253 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbcFUBF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 21:05:28 -0400
Received: by mail-ob0-f179.google.com with SMTP id xn17so1792764obc.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2016 18:04:44 -0700 (PDT)
Date: Mon, 20 Jun 2016 19:36:30 -0500
From: David Gilman <dgilman@gilslotd.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: Troubleshooting mwl8k driver issue
Message-ID: <20160621003630.GA39401@dar.local> (sfid-20160621_030534_500658_01499E18)
References: <20160604035452.GA5925@dar.local>
 <20160606065146.GK8402@wantstofly.org>
 <20160610040247.GA16190@dar.local>
 <20160617194303.GA33130@dar.local>
 <20160618084828.GN20238@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160618084828.GN20238@wantstofly.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 18, 2016 at 11:48:28AM +0300, Lennert Buytenhek wrote:
> Nothing in here seems particularly bad.  So whatever the problem is,
> I don't think it can be diagnosed from these messages alone.
> 
> I went back to the email thread, and it seems that the problem is that
> you're trying to run the card in AP mode but no traffic is making it
> through?  Is AP association working at all, or is that failing too?

The mwl8k is in AP mode and it gets associated just fine.  It'll work
for five or so minutes and then you'll get the disconnect and the log
messages in the earlier emails.  And it only happens with one of my
wireless devices - the other one will browse all day with a stable
connection to the mwl8k router.

Back in the OpenWRT issue a few more people have stuck their heads in
to say they're also seeing the same issue.

https://dev.openwrt.org/ticket/21284

-- 
David Gilman  :DG<
http://gilslotd.com
