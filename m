Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45356 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaEVSPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 14:15:09 -0400
Date: Thu, 22 May 2014 14:02:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: Re: pull request: iwlwifi-next 2014-05-22
Message-ID: <20140522180202.GD12779@tuxdriver.com> (sfid-20140522_201516_149585_610296F6)
References: <537DA58C.5050003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537DA58C.5050003@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2014 at 10:21:48AM +0300, Emmanuel Grumbach wrote:
> Hi John,
> 
> This pull request is intended for 3.16.
> 
> The regular amount of housekeeping here. I merged iwlwifi-fixes.git to be able to add the patch you didn't want in wireless.git at that stage of the -rc cycle.
> Luca has a few preparations for CSA implementation and also what seems to be a bugfix for P2P but hasn't caused issues we could notice.
> 
> Please pull.
> 
> The following changes since commit af7c603eb476216f1c27d82b802f0ce879c54ab3:
> 
>   iwlwifi: fix LED support Kconfig dependencies (2014-05-15 19:56:18 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to 999609f1206a14039db534058b251c6d5ab39322:
> 
>   iwlwifi: mvm: remove vif argument from power_update_mac (2014-05-22 10:11:17 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
