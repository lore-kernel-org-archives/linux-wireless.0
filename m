Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55110 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbaFYTaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 15:30:14 -0400
Date: Wed, 25 Jun 2014 15:18:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211-next 2014-06-24
Message-ID: <20140625191847.GH3445@tuxdriver.com> (sfid-20140625_213024_764641_4533EC11)
References: <1403626964.10831.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403626964.10831.12.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2014 at 06:22:44PM +0200, Johannes Berg wrote:
> John,
> 
> Not so much (yet?), but here it goes ... I'm planning to pull in the CSA
> work, of course.
> 
> The biggest thing here is probably Arik's TDLS rework, beyond that we
> have smaller improvements and features like David's scanning IE thing,
> Luca's queue work, some CSA work, etc. Also your PID rate control
> removal, of course.
> 
> Let me know if any issues show up.
> 
> johannes
> 
> The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:
> 
>   Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git HEAD
> 
> for you to fetch changes up to 79c3cc0d22358a383b1196aea869e620ec2faf37:
> 
>   mac80211: split sched scan IEs (2014-06-24 15:47:52 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
