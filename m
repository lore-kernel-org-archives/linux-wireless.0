Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52124 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135AbaLJOJb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 09:09:31 -0500
Message-ID: <1418220560.3460.8.camel@sipsolutions.net> (sfid-20141210_150942_355147_E6F2070F)
Subject: Re: [OpenWrt-Devel] ath9k / no more 'multicast_received_frame_count'
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Bastian Bittorf <bittorf@bluebottle.com>,
	mailinglist <openwrt-devel@lists.openwrt.org>,
	linux-wireless@vger.kernel.org
Date: Wed, 10 Dec 2014 15:09:20 +0100
In-Reply-To: <21640.21270.761643.368938@gargle.gargle.HOWL>
References: <20141210105509.GN7713@medion.lan>
	 <21640.21270.761643.368938@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-10 at 19:35 +0530, Sujith Manoharan wrote:
> Bastian Bittorf wrote:
> > since some weeks the file
> > '/sys/kernel/debug/ieee80211/$phy/statistics/multicast_received_frame_count'
> > is not updated anymore. is this intended?
> 
> Reverting b8fff407a180286aa683d543d878d98d9fc57b13 in wireless-testing
> appears to fix the issue (with ath9k).

https://bugzilla.kernel.org/show_bug.cgi?id=89431

johannes

