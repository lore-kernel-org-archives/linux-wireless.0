Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934664AbbLQDTS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 22:19:18 -0500
Date: Thu, 17 Dec 2015 11:19:12 +0800
From: Dave Young <dyoung@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stefan Lippers-Hollmann <s.l-h@gmx.de>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] wireless: change cfg80211 regulatory domain info as
 debug messages
Message-ID: <20151217031912.GB3821@dhcp-128-65.nay.redhat.com> (sfid-20151217_042029_544931_BB6D1379)
References: <20151115073105.GA18846@dhcp-128-65.nay.redhat.com>
 <20151115192547.3fd1b3cc@mir>
 <1448020533.3141.27.camel@sipsolutions.net>
 <20151123013740.GA27383@dhcp-128-32.nay.redhat.com>
 <1449843990.2324.11.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1449843990.2324.11.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 12/11/15 at 03:26pm, Johannes Berg wrote:
> On Mon, 2015-11-23 at 09:37 +0800, Dave Young wrote:
> 
> > Seems there're a lot of other wireless messages. Should we refactor 
> > them as well? I still did not get chance to see where is the code.
> > (My wireless driver being used is iwlwifi)
> 
> Most are probably from net/mac80211/.
> 
> > # dmesg|grep "Limiting TX power"|wc
> >    4128   49600  360052
> > 
> 
> I fixed this one recently, due to a bug it was printed all the time
> instead of just once when taking effect.

Cool, has the fix been in mainline or somewhere else?

Thanks
Dave
