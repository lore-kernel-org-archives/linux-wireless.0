Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52359 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2FKPzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 11:55:04 -0400
Message-ID: <1339430102.4520.30.camel@jlt3.sipsolutions.net> (sfid-20120611_175509_077609_99B6E269)
Subject: Re: kernel-doc warnings (3.5-rc1)
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Date: Mon, 11 Jun 2012 17:55:02 +0200
In-Reply-To: <4FD61395.8030901@xenotime.net>
References: <4FD28ED7.6070506@xenotime.net>
		 (sfid-20120609_014646_473500_8E65425E) <1339229158.4539.4.camel@jlt3.sipsolutions.net>
	 <1339229241.4539.5.camel@jlt3.sipsolutions.net>
	 <4FD61395.8030901@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-11 at 08:49 -0700, Randy Dunlap wrote:

> There are still 2 warnings from sta_info.h after applying
> your patch:
> 
> Warning(net/mac80211/sta_info.h:384): No description found for parameter 't_offset_setpoint'
> Warning(net/mac80211/sta_info.h:384): No description found for parameter 'ch_type'

Right, I wasn't sure what the descriptions should be so asked Javier &
team to address those.

johannes

