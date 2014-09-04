Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48342 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaIDSPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 14:15:13 -0400
Date: Thu, 4 Sep 2014 14:05:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: pull request: iwlwifi-next 2014-09-03
Message-ID: <20140904180505.GI3467@tuxdriver.com> (sfid-20140904_201517_554536_ACDB5913)
References: <540771E5.6080908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 03, 2014 at 10:54:13PM +0300, Emmanuel Grumbach wrote:
> Hi John,
> 
> This is a pull request for 3.18.
> 
> We have a new big thing coming up which is called Dynamic Queue Allocation (or DQA).
> This is a completely new way to work with the Tx queues and it requires major refactoring.
> This is being done by Johannes and Avri.
> Besides this, Johannes disables U-APSD by default because of APs that would disable A-MPDU if the association supports U-ASPD.
> Luca contributed to the power area which he was cleaning up on the way while working on CSA.
> A few more random things here and there.
> 
> Please pull. I have checked that it doesn't conflict with iwlwifi-fixes.git, but let me know
> if you have other issues.
> Thanks!
> 
> The following changes since commit 433ab34d26e29d0f036c3f514a09ae96f973d8c5:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-08-22 14:33:18 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to 712b24adc105518f7cbbb6f9f353efea48954bb9:
> 
>   iwlwifi: mvm: clean up AUX station handling (2014-09-03 22:49:13 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
