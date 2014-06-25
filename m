Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54336 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaFYSaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 14:30:11 -0400
Date: Wed, 25 Jun 2014 14:21:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: Re: pull request: iwlwifi 2014-06-24
Message-ID: <20140625182103.GC3445@tuxdriver.com> (sfid-20140625_203019_258924_BA216A7D)
References: <53A9D396.1020306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A9D396.1020306@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2014 at 10:37:58PM +0300, Emmanuel Grumbach wrote:
> Hi John,
> 
> I have been travelling so this comes a bit late. Nevertheless, it is relatively small.
> 
> I have here a fix from Eliad for scheduled scan: it fixes a firmware assertion. Arik reverts a patch I made that didn't take into account that 3160 doesn't have UAPSD and hence, we can't assume that all newer firmwares support the feature. Here too, the visible effect is a firmware assertion. Along with that, we have a few fixes and additions to the device list.
> 
> Please tell me if you have problems. Thanks!
> 
> The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:
> 
>   Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to a42c9fcc4a88cdd246fab3bcf06c4487afee3d88:
> 
>   Revert "iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag" (2014-06-24 22:01:46 +0300)
> 
> ----------------------------------------------------------------
> Arik Nemtsov (1):
>       Revert "iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag"
> 
> Eliad Peller (1):
>       iwlwifi: mvm: rework sched scan channel configuration
> 
> Oren Givon (1):
>       iwlwifi: update the 7265 series HW IDs

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
