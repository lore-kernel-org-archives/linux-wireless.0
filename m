Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56347 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbaAMTpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 14:45:14 -0500
Date: Mon, 13 Jan 2014 14:41:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211-next 2014-01-13
Message-ID: <20140113194154.GE14400@tuxdriver.com> (sfid-20140113_204517_911490_731C4BAC)
References: <1389620906.5008.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389620906.5008.12.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 13, 2014 at 02:48:26PM +0100, Johannes Berg wrote:
> John,
> 
> I'm hoping this pull request will still make it for 3.14, but I guess
> it's not a huge loss if it doesn't, I'd just have to rebase around to
> get things reorganised properly.
> 
> This tim eI have uAPSD fixes since I was working on that, hwsim
> improvements to make dynamic radios possible for the test suite, the
> evidently long-overdue channel_change_time removal and a few other small
> collected fix and improvements.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> ---
> 
> The following changes since commit 32db6b54dfba38aa8fa4072b2a3fc6425139166a:
> 
>   mac80211: Add support for QoS mapping (2013-12-19 16:30:58 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 26b0e411d37a2ca5992d02884dc3fa4e1907e598:
> 
>   mac80211_hwsim: restore regulatory testing functionality (2014-01-10 20:12:59 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
