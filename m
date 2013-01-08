Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:33648 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750969Ab3AHDL2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 22:11:28 -0500
Message-ID: <1357614687.12749.41.camel@joe-AO722> (sfid-20130108_041155_448267_2C47730D)
Subject: Re: [RFC PATCH] vsprintf: Add %p*D extension for 80211 SSIDs
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	stas.yakovlev@gmail.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Mon, 07 Jan 2013 19:11:27 -0800
In-Reply-To: <50EB8B1A.9000404@asianux.com>
References: <50E82D7D.4090107@asianux.com>
	 <1357396966.21156.4.camel@joe-AO722> <50EA37CE.1090901@asianux.com>
	 <1357528746.4940.31.camel@joe-AO722> <1357534195.21481.31.camel@joe-AO722>
	 (sfid-20130107_055017_668200_9F1C3EAF) <1357544828.9912.0.camel@jlt4.sipsolutions.net>
	 <1357579362.21481.45.camel@joe-AO722> <50EB8B1A.9000404@asianux.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-08 at 10:57 +0800, Chen Gang wrote:
> 于 2013年01月08日 01:22, Joe Perches 写道:
> > On Mon, 2013-01-07 at 08:47 +0100, Johannes Berg wrote:
> >> > print_ssid() is used in two or
> >> > three legacy drivers only, not in any modern driver, and is unlikely to
> >> > be used in the more modern drivers due to tracing etc.
> > Swell.  It was just another way to correct those overrun
> > errors Chen Gang found.
> > 
>   sorry, I am not quite clear about what you said.

You found some overrun errors and proposed a patch.
Your solution could output incomplete SSIDs.

I proposed a different patch that would fully output
any binary/non-ascii printable SSID.

I also proposed a different mechanism to avoid the
overrun via printk and also avoid possibly excessive
stack consumption as a means for John Linville to
select 1 of the above options.

I don't care what is done with any of those proposed
patches.

Clear?

