Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48802 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3A1UAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 15:00:23 -0500
Date: Mon, 28 Jan 2013 14:47:32 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi 2013-01-24
Message-ID: <20130128194731.GC2107@tuxdriver.com> (sfid-20130128_210028_389355_AE05EFCF)
References: <1359045335.21908.8.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359045335.21908.8.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 24, 2013 at 05:35:35PM +0100, Johannes Berg wrote:
> John,
> 
> Also for iwlwifi, I have one fix from Emmanuel reverting a previous fix
> that caused more trouble than it's worth.
> 
> Please pull. Thanks,
> johannes
> 
> The following changes since commit c3e5d7181afb66657393066bccce0956fab09ab3:
> 
>   iwlwifi: audit single frames from AGG queue in RS (2013-01-16 14:20:20 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to ae023b2795d36f0f077e157428eb7eafa29ee412:
> 
>   Revert "iwlwifi: fix the reclaimed packet tracking upon flush queue" (2013-01-24 12:54:24 +0100)
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       Revert "iwlwifi: fix the reclaimed packet tracking upon flush queue"
> 
>  drivers/net/wireless/iwlwifi/dvm/tx.c | 24 +++++++-----------------
>  1 file changed, 7 insertions(+), 17 deletions(-)
> 

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
