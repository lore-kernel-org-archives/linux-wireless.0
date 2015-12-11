Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33503 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbbLKO0f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 09:26:35 -0500
Message-ID: <1449843990.2324.11.camel@sipsolutions.net> (sfid-20151211_152654_723985_07574D4A)
Subject: Re: [PATCH] wireless: change cfg80211 regulatory domain info as
 debug messages
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave Young <dyoung@redhat.com>
Cc: Stefan Lippers-Hollmann <s.l-h@gmx.de>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net
Date: Fri, 11 Dec 2015 15:26:30 +0100
In-Reply-To: <20151123013740.GA27383@dhcp-128-32.nay.redhat.com>
References: <20151115073105.GA18846@dhcp-128-65.nay.redhat.com>
	 <20151115192547.3fd1b3cc@mir> <1448020533.3141.27.camel@sipsolutions.net>
	 <20151123013740.GA27383@dhcp-128-32.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-11-23 at 09:37 +0800, Dave Young wrote:

> Seems there're a lot of other wireless messages. Should we refactor 
> them as well? I still did not get chance to see where is the code.
> (My wireless driver being used is iwlwifi)

Most are probably from net/mac80211/.

> # dmesg|grep "Limiting TX power"|wc
>    4128   49600  360052
> 

I fixed this one recently, due to a bug it was printed all the time
instead of just once when taking effect.

johannes
