Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338Ab0DFG6k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 02:58:40 -0400
Subject: Re: Compat wireless with kernel 2.6.33
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Matteo Croce <technoboy85@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <o2o43e72e891004051708hea73a30fu3cc40693c7e8529c@mail.gmail.com>
References: <40101cc31003200759u447b625ct6f48aa6003593dac@mail.gmail.com>
	 <t2g43e72e891004051634i8233e5dan23d60ce985613726@mail.gmail.com>
	 <n2u40101cc31004051654t38145f16h7066338cc2804e53@mail.gmail.com>
	 <o2o43e72e891004051708hea73a30fu3cc40693c7e8529c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 08:58:38 +0200
Message-ID: <1270537118.3929.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-05 at 17:08 -0700, Luis R. Rodriguez wrote:

> > Please do not disable wext until nl80211 can really replace it.
> 
> wext is already disabled by default if you don't have a driver that requires it.

Not yet:

config CFG80211_WEXT
        bool "cfg80211 wireless extensions compatibility"
        depends on CFG80211
        select WEXT_CORE   
        default y
        help
          Enable this option if you need old userspace for wireless
          extensions with cfg80211-based drivers.

johannes

