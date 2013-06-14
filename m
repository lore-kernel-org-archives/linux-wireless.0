Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50236 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3FNRpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 13:45:10 -0400
Date: Fri, 14 Jun 2013 13:32:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2013-06-14
Message-ID: <20130614173210.GA28497@tuxdriver.com> (sfid-20130614_194521_900412_8101F3FC)
References: <1371206930.8278.8.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371206930.8278.8.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 14, 2013 at 12:48:50PM +0200, Johannes Berg wrote:
> John,
> 
> Here are some more things for -next. I will have another pull request
> some time next week because we're preparing to release the firmware for
> the 7000 series devices, and unfortunately that will require an API
> bump.
> 
> This time I have a number of cleanups, a small fix from Emmanuel and two
> performance improvements that combined reduce our driver's CPU
> utilisation as much as 75% in high TX-throughput scenarios.
> 
> johannes
> 
> 
> The following changes since commit 8eb3871076875f247483f4a1fe6713e6d440c53e:
> 
>   iwlwifi: mvm: Update the supported interface combinations (2013-06-11 20:17:06 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to adaf69186c24100d34c2fb107dacd33546cad3c5:
> 
>   iwlwifi: mvm: remove obsolete comment (2013-06-13 16:43:16 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
