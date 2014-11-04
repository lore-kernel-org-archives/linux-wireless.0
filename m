Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57483 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaKDVaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 16:30:10 -0500
Date: Tue, 4 Nov 2014 16:16:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211-next 2014-11-04
Message-ID: <20141104211601.GE31033@tuxdriver.com> (sfid-20141104_223015_676193_8DC2F0B2)
References: <1415096975.2064.16.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415096975.2064.16.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 04, 2014 at 11:29:35AM +0100, Johannes Berg wrote:
> Hi John,
> 
> This comes relatively late, but between other things I didn't get around
> to it until now, sorry about that.
> 
> We have quite a bit of content, see below.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> ---
> 
> The following changes since commit 35a9ad8af0bb0fa3525e6d0d20e32551d226f38e:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2014-10-08 21:40:54 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-john-2014-11-04
> 
> for you to fetch changes up to bd2bc23292ccf5b75e32fa3090162c38c0826352:
> 
>   mac80211: replace restart_complete() with reconfig_complete() (2014-11-04 11:18:19 +0100)
> 
> ----------------------------------------------------------------
> This relatively large batch of changes is comprised of the
> following:
>  * large mac80211-hwsim changes from Ben, Jukka and a bit myself
>  * OCB/WAVE/11p support from Rostislav on behalf of the Czech Technical
>    University in Prague and Volkswagen Group Research
>  * minstrel VHT work from Karl
>  * more CSA work from Luca
>  * WMM admission control support in mac80211 (myself)
>  * various smaller fixes, spelling corrections, and minor API additions

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
