Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7314 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757584AbYFZTTs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 15:19:48 -0400
Subject: Re: [Q] ath5k : doesn't support AP mode?
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	cs010101@gmail.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1214501000.3783.0.camel@johannes.berg>
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
	 <200806261821.31643.mb@bu3sch.de> <1214498071.30722.22.camel@dv>
	 <200806261846.17962.mb@bu3sch.de>  <1214501000.3783.0.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 14:03:23 -0400
Message-Id: <1214503403.18039.6.camel@dv> (sfid-20080626_212020_442318_2297D0D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-26 at 19:23 +0200, Johannes Berg wrote:
> > > What's the current TODO list for the AP mode?
> > 
> > I think there are some issues with the rates.
> > Maybe more. I don't really know.
> 
> It's on the todo list on wireless.kernel.org

I see it now:
http://wireless.kernel.org/en/developers/todo-list#APsupport

It would be great to split the list into categories.  I don't think
"data frames on cooked monitor" make the AP mode non-compliant.

I also suspect that certain fixed are needed only for 802.11g or 802.11b
compliance, but not for the original 802.11 compliance.

Say, if we limit the rate to 1 Mbps, are there any issues that really
make us non-compliant?

-- 
Regards,
Pavel Roskin
