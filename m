Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37823 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbXIUWCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 18:02:52 -0400
Date: Fri, 21 Sep 2007 15:02:53 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	stable@kernel.org, Rob Hussey <robjhussey@gmail.com>
Subject: Re: [stable] [PATCH] cfg80211: fix initialisation if built-in
Message-ID: <20070921220253.GA32585@kroah.com>
References: <1189424685.4506.63.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1189424685.4506.63.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 10, 2007 at 01:44:45PM +0200, Johannes Berg wrote:
> When cfg80211 is built into the kernel it needs to init earlier
> so that device registrations are run after it has initialised.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

When this goes into Linus's tree, please resend it to the
stable@kernel.org address so we can add it to our queue.

thanks,

greg k-h
