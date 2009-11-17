Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:36097 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZKQREZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 12:04:25 -0500
Date: Tue, 17 Nov 2009 09:04:20 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>, netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RFC] mac80211: disallow bridging managed/adhoc interfaces
Message-ID: <20091117090420.0434edc3@nehalam>
In-Reply-To: <1258476223.21197.0.camel@johannes.local>
References: <1258465585.3682.7.camel@johannes.local>
	<200911171504.54170.mb@bu3sch.de>
	<1258466868.3682.13.camel@johannes.local>
	<20091117083741.1b165274@nehalam>
	<1258476223.21197.0.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 17 Nov 2009 17:43:43 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Tue, 2009-11-17 at 08:37 -0800, Stephen Hemminger wrote:
> 
> > But there are people bridging wireless, and hostap even has a mode for
> > that. 
> 
> But that's the AP side, which this patch doesn't attempt to prevent. It
> just makes no sense to bridge when connected to an AP or part of an
> IBSS.
> 

Then how does this work now? And will your change break it?

                             kvm1
                            /
     ====> wlan0  --- bridge-- kvm2
                            \
                             kvm3
