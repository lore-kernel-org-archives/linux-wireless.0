Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58476 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaEHPaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 11:30:14 -0400
Date: Thu, 8 May 2014 11:29:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: Re: pull request: iwlwifi 2014-05-07
Message-ID: <20140508152953.GD6180@tuxdriver.com> (sfid-20140508_173525_736359_9420128D)
References: <536A90BD.8010204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <536A90BD.8010204@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 07, 2014 at 10:59:57PM +0300, Emmanuel Grumbach wrote:
> Hi John,
> 
> This is a pull request intended for 3.15 release.
> 
> Alex fixes the scan by disabling the fragmented scan. David prevents scan offload while associated, the firmware seems not to like it. I fix a stupid bug I made in BT Coex, and fix a bad #ifdef clause in rate scaling.
> Along with that there is a fix for a NULL pointer exception that can happen if we load the driver and our ISR gets called because the interrupt line is shared. The fix has been tested by the reporter.
> 
> Please pull.
> 
> The following changes since commit a6bc92803e7f765e02c923cf37c8e280e729642a:
> 
>   iwlwifi: mvm: BT Coex - fix Look Up Table (2014-04-13 16:51:07 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git master
> 
> for you to fetch changes up to 83f7a85f1134c6e914453f5747435415a23d516b:
> 
>   iwlwifi: pcie: disable interrupts upon PCIe alloc (2014-05-07 22:54:32 +0300)

Pulling now...  Please limit any further fix requests to very small
and important fixes only.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
