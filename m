Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40120 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab3ADVPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 16:15:11 -0500
Date: Fri, 4 Jan 2013 16:13:16 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi 2013-01-03
Message-ID: <20130104211315.GD21871@tuxdriver.com> (sfid-20130104_221515_230998_D6708B72)
References: <1357224173.9741.18.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1357224173.9741.18.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 03, 2013 at 03:42:53PM +0100, Johannes Berg wrote:
> John,
> 
> I have two fixes for iwlwifi: one to fix a lost return value that was
> dropped in a previous patch and could cause "nobody cared" IRQ messages,
> and one to work around a firmware issue.
> 
> Please pull.
> 
> Thanks,
> johannes
> 
> 
> The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:
> 
>   Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to f590dcec944552f9a4a61155810f3abd17d6465d:
> 
>   iwlwifi: fix the reclaimed packet tracking upon flush queue (2013-01-03 15:31:15 +0100)

I'm pulling this, intending to forward it to Dave early next week.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
