Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52288 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbaAFTaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 14:30:21 -0500
Date: Mon, 6 Jan 2014 14:19:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2013-12-19
Message-ID: <20140106191938.GC10885@tuxdriver.com> (sfid-20140106_203031_478259_B3AC1FD2)
References: <1387484548.4298.16.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1387484548.4298.16.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 19, 2013 at 09:22:28PM +0100, Johannes Berg wrote:
> John,
> 
> Just before the holidays, didn't you want more pull requests? ;-)
> Sorry, but I think this should still go in...
> 
> I have a fix from Javier for mac80211_hwsim when used with wmediumd
> userspace, and a fix from Felix for buffering in AP mode.
> 
> I might not have sent in the wmediumd fix since it's mostly a debug
> tool, but hey, I have to send in a pull request for the other one anyway
> and it is a simple patch and bad bug, so ... Let me know if there's any
> problem.
> 
> johannes
> 
> ---
> 
> The following changes since commit bd02cd2549cfcdfc57cb5ce57ffc3feb94f70575:
> 
>   radiotap: fix bitmap-end-finding buffer overrun (2013-12-16 12:06:43 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 277d916fc2e959c3f106904116bb4f7b1148d47a:
> 
>   mac80211: move "bufferable MMPDU" check to fix AP mode scan (2013-12-16 21:44:05 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
