Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35026 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaLJODo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 09:03:44 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21640.21270.761643.368938@gargle.gargle.HOWL> (sfid-20141210_150347_147499_2B8695AD)
Date: Wed, 10 Dec 2014 19:35:10 +0530
To: Bastian Bittorf <bittorf@bluebottle.com>
Cc: mailinglist <openwrt-devel@lists.openwrt.org>,
	<linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
Subject: Re: [OpenWrt-Devel] ath9k / no more 'multicast_received_frame_count'
In-Reply-To: <20141210105509.GN7713@medion.lan>
References: <20141210105509.GN7713@medion.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bastian Bittorf wrote:
> since some weeks the file
> '/sys/kernel/debug/ieee80211/$phy/statistics/multicast_received_frame_count'
> is not updated anymore. is this intended?

Reverting b8fff407a180286aa683d543d878d98d9fc57b13 in wireless-testing
appears to fix the issue (with ath9k).

Sujith
