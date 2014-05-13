Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33430 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaEMTAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 15:00:12 -0400
Date: Tue, 13 May 2014 14:53:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: Re: pull request: iwlwifi 2014-05-13
Message-ID: <20140513185300.GG21204@tuxdriver.com> (sfid-20140513_210015_741941_70422014)
References: <53722142.6070105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53722142.6070105@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2014 at 04:42:26PM +0300, Emmanuel Grumbach wrote:
> Hi John,
> 
> here is a bit more content content for 3.15.
> 
> We have here a fix from David Spinadel that makes a previous fix more complete, and an off-by-one issue fixed by Eliad in the same area.
> I fix the monitor that broke on the way.
> 
> Let me know about issues you may have.
> 
> Cheers,
> 
> 
> The following changes since commit 83f7a85f1134c6e914453f5747435415a23d516b:
> 
>   iwlwifi: pcie: disable interrupts upon PCIe alloc (2014-05-07 22:54:32 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to b538b8ce76f69f7fa225bc0817bbb361b877ea23:
> 
>   iwlwifi: mvm: prevent sched scan while not idle (2014-05-13 15:05:32 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
