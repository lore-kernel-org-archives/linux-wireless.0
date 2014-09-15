Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43928 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbaIOSpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 14:45:13 -0400
Date: Mon, 15 Sep 2014 14:41:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: pull request: iwlwifi-next 2014-09-15
Message-ID: <20140915184102.GA3891@tuxdriver.com> (sfid-20140915_204517_592553_04B596AA)
References: <5416742C.3070804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2014 at 08:07:56AM +0300, Emmanuel Grumbach wrote:
> Hi John,
> 
> This is a pull request for 3.18. I have a few more patches for 3.18 that are not included here.
> This pull request was big enough without them, and they rely on mac80211 patches that are not
> in wireless-next yet. In my master branch, I merged Johannes's tag on mac80211-next to be able
> to apply these patches, I'll send you another pull request once you'll pull from Johannes. Let
> me know if you prefer me to merge wireless-next rather than mac80211-next. I just found it easier
> for me.
> I also merged iwlwifi-fixes to avoid minor conflicts.
> 
> I fix here dvm which was broken by my last pull request. Arik continues to work on TDLS
> and Luca solved a few issues in CT-Kill. Eyal keeps digging into rate scaling code, more
> to come soon. Besides this, nothing really special here.
> 
> Please pull, thanks!
> 
> The following changes since commit 712b24adc105518f7cbbb6f9f353efea48954bb9:
> 
>   iwlwifi: mvm: clean up AUX station handling (2014-09-03 22:49:13 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to f991e17ba2584e2be66476cc468f19769efd55cc:
> 
>   iwlwifi: mvm: align CSA GO NOA time event naming with the firmware (2014-09-14 22:02:24 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
