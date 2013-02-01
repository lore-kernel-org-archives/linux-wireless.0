Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50970 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab3BATaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 14:30:25 -0500
Date: Fri, 1 Feb 2013 14:20:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2013-02-01 (was: pull-request:
 iwlwifi-next 2013-01-30)
Message-ID: <20130201192030.GB29418@tuxdriver.com> (sfid-20130201_203101_495552_FBC081C5)
References: <1359579712.8010.30.camel@jlt4.sipsolutions.net>
 <1359715120.8528.11.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359715120.8528.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 01, 2013 at 11:38:40AM +0100, Johannes Berg wrote:
> John,
> 
> Please excuse my overriding an earlier pull request again. Fengguang
> Wu's build testing found that we had a few symbol conflicts between the
> two subdrivers (iwldvm and the new iwlmvm) so I fixed those. I also
> included a few more patches that we'd worked on and I put in for
> publishing since then.
> 
> So what I have here is some cleanups, preparations and the new MVM
> (multi-virtual MAC) driver itself and (this is new) some work on the
> transport API as well as a message flooding fix.
> 
> Let me know if there are any problems.
> 
> johannes
> 
> The following changes since commit c331997b6c9ad7f4b8075e6e60d3caa6e36f5938:
> 
>   wil6210: fix wil_vring_init_tx status (2013-01-30 15:07:19 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to e56b04efc1f795da42cf1d9651b52a4a5bebd730:
> 
>   iwlwifi: move register access lock into transport (2013-02-01 11:27:22 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
