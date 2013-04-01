Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57520 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759297Ab3DATPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 15:15:52 -0400
Date: Mon, 1 Apr 2013 15:10:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-fixes 2013-03-28
Message-ID: <20130401191006.GA3526@tuxdriver.com> (sfid-20130401_211557_166970_07EDD4DB)
References: <1364484949.10397.7.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1364484949.10397.7.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 28, 2013 at 04:35:49PM +0100, Johannes Berg wrote:
> Hi John,
> 
> I know you just pulled my other iwlwifi-fixes request ... but in the
> meantime I debugged with Alex Romosan, you probably saw the thread, and
> thus have another fix and I wanted to send it to you.
> 
> The only fix here is to the passive-no-RX firmware regulatory
> enforcement driver support code to not drop auth frames in quick
> succession, leading to not being able to connect to APs on passive
> channels in certain circumstances.
> 
> Let me know if there's any issue. Thanks,
> johannes
> 
> 
> The following changes since commit 2d5d50ee596361566f7f84300117cba7d7672bc5:
> 
>   iwlwifi: dvm: don't send HCMD in restart flow (2013-03-20 12:10:57 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to b8730b403aee94db4631bfefb546a6ce8c287dc2:
> 
>   iwlwifi: dvm: fix the passive-no-RX workaround (2013-03-28 16:31:26 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
