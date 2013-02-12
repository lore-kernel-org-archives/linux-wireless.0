Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47181 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab3BLQPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:15:34 -0500
Date: Tue, 12 Feb 2013 11:08:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2012-02-11
Message-ID: <20130212160816.GB2086@tuxdriver.com> (sfid-20130212_171538_892134_C9DEC397)
References: <1360621691.8738.60.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360621691.8738.60.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 11, 2013 at 11:28:11PM +0100, Johannes Berg wrote:
> Hi John,
> 
> I think I have enough changes for a new pull request ...
> 
> This time, I have relatively large number of fixes in various areas of
> the code (a memory leak in regulatory, an RX race in mac80211, the new
> radar checking caused a P2P device problem, some mesh issues with
> stations, an older bug in tracing and for kernel-doc) as well as a
> number of small new features. The biggest (in the diffstat) is my work
> on hidden SSID tracking.
> 
> Please pull and/or let me know of issues.
> 
> Thanks,
> johannes
> 
> -----
> 
> The following changes since commit 8708aac79e4572ba673d7a21e94ddca9f3abb7fc:
> 
>   rtlwifi: rtl8192cu: Add new USB ID (2013-02-08 14:51:43 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 9c35d7d2368f54313b988a01c408e5cf863ffd9e:
> 
>   mac80211: Add flushes before going off-channel (2013-02-11 22:52:21 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
