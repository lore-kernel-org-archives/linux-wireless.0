Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sapphire.tuxdriver.com ([70.61.120.61]:51412 "EHLO
	linville-x1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756895Ab3DWSRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 14:17:06 -0400
Date: Tue, 23 Apr 2013 14:10:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: pull request: b43-next 2013-04-23
Message-ID: <20130423181044.GA7871@tuxdriver.com> (sfid-20130423_233110_694724_DDCC024C)
References: <CACna6rxOfr7jWKHfrGWC09Sw6XKShdexpkRKLeVhfuON5d7Bgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rxOfr7jWKHfrGWC09Sw6XKShdexpkRKLeVhfuON5d7Bgw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 23, 2013 at 03:49:51PM +0200, Rafał Miłecki wrote:
> Hi John,
> 
> Let me ask you once again for pulling my b43-next tree. I didn't add any new
> patches since the last pull request, I just dropped ssb patch you already
> pushed into your tree.
> 
> Let me remind the changes for b43:
> > Changes include:
> > 1) Minor improvements for HT-PHY code (BCM4331)
> > 2) Code cleaning for HT-PHY and N-PHY
> 
> Sorry for the problem with the previous pull request. Your wireless-next was
> slighlty too old for me (nouveau regression in 3.9-rc1) so I've based my tree
> on wireless-testing. That wasn't too bright idea.
> 
> To rebase the tree I've simply used:
> git rebase --onto wireless-next/master master~21 master
> 
> 
> The following changes since commit c43933e61ea9b630521bf0d5cf06c155478308a7:
> 
>   mwifiex: remove redundant initialization for bss_descriptor
> (2013-04-22 15:38:36 -0400)
> 
> are available in the git repository at:
> 
>   git://git.infradead.org/users/rafal/b43-next.git master
> 
> for you to fetch changes up to 0c201cfbfd47c40ee0cedbcd96e4fbaa85c5fc50:
> 
>   b43: N-PHY: don't use deprecated b43_radio_foo16 (2013-04-23 12:27:58 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
