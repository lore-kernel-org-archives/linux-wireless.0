Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47111 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbYJBTLV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 15:11:21 -0400
Subject: Re: [PATCH 0/5] wireless: single escape_essid implementation and
	related cleanups
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1222827352-1978-1-git-send-email-linville@tuxdriver.com>
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
	 <1222827352-1978-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 02 Oct 2008 15:10:37 -0400
Message-Id: <1222974637.12505.5.camel@72-58-93-37.area3.spcsdns.net> (sfid-20081002_211125_678341_4ED67756)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-09-30 at 22:15 -0400, John W. Linville wrote:
> This is a repost of my escape_essid consolidation.  Also included are
> some suggested changes from the original post and a few cleanups.  There
> is still plenty to be done -- of course, this isn't really high priority
> work either...
> 
> [PATCH 1/5] wireless: consolidate on a single escape_essid implementation
> [PATCH 2/5] wireless: remove NETWORK_EMPTY_ESSID flag
> [PATCH 3/5] wireless: escape_ssid should handle non-printables
> [PATCH 4/5] wireless: use individual buffers for printing ssid values
> [PATCH 5/5] wireless: avoid some net/ieee80211.h vs. linux/ieee80211.h conflicts
> 
> Comments welcome!

I like it!  Though for ipw2200, the bits of code that check
NETWORK_EMPTY_SSID before associating might still be valid?  You can't
really associate with a network (or start an adhoc network) unless you
know the SSID, right?

Dan


