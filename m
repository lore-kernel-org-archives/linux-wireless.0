Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbbKPB6x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2015 20:58:53 -0500
Date: Mon, 16 Nov 2015 09:58:45 +0800
From: Dave Young <dyoung@redhat.com>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net,
	johannes@sipsolutions.net
Subject: Re: [PATCH] wireless: change cfg80211 regulatory domain info as
 debug messages
Message-ID: <20151116015845.GA3439@dhcp-128-65.nay.redhat.com> (sfid-20151116_025925_866405_7B33C69C)
References: <20151115073105.GA18846@dhcp-128-65.nay.redhat.com>
 <20151115192547.3fd1b3cc@mir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151115192547.3fd1b3cc@mir>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 11/15/15 at 07:25pm, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On 2015-11-15, Dave Young wrote:
> > cfg80211 module prints a lot of messages like below. Actually printing
> > once is acceptable but sometimes it will print again and again, it looks
> > very annoying. It is better to change these detail messages to debugging
> > only.
> 
> It is a lot of info, easily repeated 3 times on boot, but it's also the
> only real chance to determine why you ended up with the regulatory 
> domain settings you got, rather than just the values itself. Given that
> a lot (most?) of officially shipping wireless devices are misconfigured
> (wrong EEPROM regdom settings for the region they're sold in) and 
> considering that the limits can even change at runtime (IEEE 802.11d), 
> it is imho quite important not just to be able what the current 
> restrictions (iw reg get) are, but also why the kernel settled on those.

If it is really important then a kernel cmdline param to disable the logs
sounds better?

Thanks
Dave
