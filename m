Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56802 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759679Ab3DHSqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 14:46:05 -0400
Date: Mon, 8 Apr 2013 14:31:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-04-08
Message-ID: <20130408183139.GA25564@tuxdriver.com> (sfid-20130408_204609_579512_662BE23C)
References: <1365421010.25475.5.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365421010.25475.5.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 08, 2013 at 01:36:50PM +0200, Johannes Berg wrote:
> (resend with list CC'ed, oops)
> 
> John,
> 
> Sadly, I have another pull request -- the idle handling fix broke LED
> handling in some cases.
> 
> johannes
> 
> 
> The following changes since commit 90e0970f8788cef2c8f5183af5a98f4f94600faf:
> 
>   cfg80211: sched_scan_mtx lock in cfg80211_conn_work() (2013-03-30 22:33:19 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 62a40a15554d6924a58b3e9f8756e0d683dc9c0c:
> 
>   mac80211: fix LED in idle handling (2013-04-08 13:12:05 +0200)

Pulling now -- hopefully there is still time...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
