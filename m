Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38475 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966705AbZLIARc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 19:17:32 -0500
Date: Tue, 8 Dec 2009 19:17:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: correctly report signal value for IEEE80211_HW_SIGNAL_UNSPEC
Message-ID: <20091209001737.GA26024@tuxdriver.com>
References: <1260310548-18161-1-git-send-email-linville@tuxdriver.com> <1260311613.32227.5.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1260311613.32227.5.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 08, 2009 at 11:33:33PM +0100, Johannes Berg wrote:
> On Tue, 2009-12-08 at 17:15 -0500, John W. Linville wrote:
> > This part was missed in "cfg80211: implement get_wireless_stats",
> > probably because sta_set_sinfo already existed and was only handling
> > dBm signals.
> 
> Now I do have to wonder how you found this, but yeah, looks right to me.

Someone reported it at bugzilla.kernel.org, and I tracked it down
with an RTL8185 cardbus card plugged into a box running one of my
pre-RHEL5.5 test kernels... :-)

John
--
John W. Linvlle
linville@tuxdriver.com
