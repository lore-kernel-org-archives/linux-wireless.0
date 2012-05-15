Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39363 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965929Ab2EOWRu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 18:17:50 -0400
Date: Tue, 15 May 2012 18:01:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull request: wl12xx 2012-05-03
Message-ID: <20120515220105.GI24572@tuxdriver.com> (sfid-20120516_001815_173118_E0F9EED9)
References: <1336050471.12189.37.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336050471.12189.37.camel@cumari.coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 03, 2012 at 04:07:51PM +0300, Luciano Coelho wrote:
> Hi John,
> 
> This is another pull request intended for 3.5.  A few fixes here and
> there, stuff that has been pending for a while and I hadn't had the time
> to apply.  Nothing really major.
> 
> Please pull or let me know if there's any problem. This tree is based on
> wireless-next/master and the head I want you to pull from is
> 422823e85d3957b64c573a2f15c6172d78de1e00. 
> 
> Thanks! 
> 
> The following changes since commit 0a9b3782ef402d27c3e6d1b116f10076a9dd088c:
> 
>   {nl,cfg,mac}80211: Allow user to see/configure HT protection mode (2012-05-02 14:30:55 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville
> 
> for you to fetch changes up to 422823e85d3957b64c573a2f15c6172d78de1e00:
> 
>   wlcore/wl12xx: implement better beacon loss handling (2012-05-03 15:45:03 +0300)

I used the magic of git to fix this up after last week's rebasing.
Please do take the opportunity to verify the result.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
