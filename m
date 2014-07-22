Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39306 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbaGVRaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 13:30:13 -0400
Date: Tue, 22 Jul 2014 13:22:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2014-07-21
Message-ID: <20140722172222.GB1299@tuxdriver.com> (sfid-20140722_193018_471534_AF5FB0C6)
References: <53CD5785.80408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53CD5785.80408@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 21, 2014 at 09:10:13PM +0300, Emmanuel Grumbach wrote:
> Hi John,
> 
> This is a pull request for 3.16.
> 
> It includes a merge damage fix. This region has been changed in -next and -fixes quite a few times and apparently, I failed to handle it properly, so here the fix.
> Along with that I have a fix from Eliad to properly handle overlapping BSS in AP mode.
> 
> Let me know if you have issues with this.
> Thanks!
> 
> The following changes since commit dc271ee0d04d12d6bfabacbec803289a7072fbd9:
> 
>   iwlwifi: mvm: disable CTS to Self (2014-07-03 20:55:18 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git master
> 
> for you to fetch changes up to 4601879419f94a89fcbf427b4d3bfbf4ce294174:
> 
>   iwlwifi: mvm: pass beacons from foreign APs (2014-07-21 10:38:25 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
