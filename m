Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:51451 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752521AbXFVPjl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 11:39:41 -0400
Date: Fri, 22 Jun 2007 17:39:40 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Andy Green <andy@warmcat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
Message-ID: <20070622173940.30280046@griffin.suse.cz>
In-Reply-To: <467BDCB1.1010604@warmcat.com>
References: <1182418939.10821.8.camel@johannes.berg>
	<20070621143558.68fc8e4a@griffin.suse.cz>
	<1182429920.21939.1.camel@johannes.berg>
	<20070621151441.500d62d5@griffin.suse.cz>
	<20070622154545.29eeebdb@griffin.suse.cz>
	<467BDCB1.1010604@warmcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 22 Jun 2007 15:29:05 +0100, Andy Green wrote:
> But for any nontrivial use, you need to capture RX and not blindly
> inject, and so you have a monitor mode interface up anyway.

No, why? You can encapsulate received management frames (only the ones
that need to go to user space or so) in the same way and send them
through the regular interface.

 Jiri

-- 
Jiri Benc
SUSE Labs
