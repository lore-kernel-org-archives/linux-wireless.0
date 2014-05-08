Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58646 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaEHPpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 11:45:10 -0400
Date: Thu, 8 May 2014 11:37:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: Re: pull request: iwlwifi-next 2014-05-07
Message-ID: <20140508153732.GE6180@tuxdriver.com> (sfid-20140508_174516_433878_541653B1)
References: <536A8EE3.2050906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 07, 2014 at 10:52:03PM +0300, Emmanuel Grumbach wrote:
> Hi John,
> 
> I have here another pull request for 3.16.
> I merged wireless-next.git because of dependencies on changes in mac80211. I merged iwlwifi-fixes.git (that feeds wireless.git) because of dependencies in the rate scaling changes that were sent to wireless.git.
> 
> Eran continues to work on new devices, Eyal is still digging in the rate control stuff, and Johannes added new functionality to the debug system we have in place now along with a few cleanups he made on the way.
> That's pretty much it.
> 
> Please pull. 
> 
> The following changes since commit 48d11dc37977614a461bfedddc52d1c651bc279f:
> 
>   rsi: Changing opcode for sta mode according to changes in firmware (2014-04-30 12:13:16 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to 017a64161f6d082f6e3ed85646217bd7217af15a:
> 
>   iwlwifi: mvm: rs: enable MCS9 for Tx (2014-05-07 22:44:43 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
