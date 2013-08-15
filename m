Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48914 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3HOTpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 15:45:10 -0400
Date: Thu, 15 Aug 2013 15:41:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac802111 2013-08-15
Message-ID: <20130815194121.GE2133@tuxdriver.com> (sfid-20130815_214515_047808_9FBFCFFD)
References: <1376581601.14084.14.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1376581601.14084.14.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 15, 2013 at 05:46:41PM +0200, Johannes Berg wrote:
> John,
> 
> I have two more fixes ...
> 
> This time, I have one fix from Dan Carpenter for users of
> nl80211hdr_put(), and one fix from myself fixing a regression with the
> libertas driver.
> 
> Please let me know if there's any problem.
> 
> johannes
> 
> The following changes since commit ddfe49b42d8ad4bfdf92d63d4a74f162660d878d:
> 
>   mac80211: continue using disabled channels while connected (2013-07-31 21:18:17 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to dee8a9732e713480075adbbca8eb220c5b8d1216:
> 
>   cfg80211: don't request disconnect if not connected (2013-08-14 14:00:19 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
