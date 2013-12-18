Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46476 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab3LRUPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 15:15:17 -0500
Date: Wed, 18 Dec 2013 15:12:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: pull request: iwlwifi-next 2013-12-17
Message-ID: <20131218201226.GF3096@tuxdriver.com> (sfid-20131218_211523_282636_FC582411)
References: <52B0B72A.5070704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 17, 2013 at 10:42:18PM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> here is another batch for 3.14.
> 
> I have hear quite a few things. Alex continues his work on power
> management. Arik is reworking the transport API by unifying redudant
> APIs and making error handling more generic. Eyal keeps on digging in
> the rate scaling code.
> We also have two new features - Max is using the brand new generic
> cipher infrastructure in mac80211, and Lilach implements the smart fifo
> which allows to save power by making interrupt coalescing smarter.
> 
> Let me know about issues you might have (hopefully none)!
> 
> The following changes since commit 9d10849e4ea8bf9d8da80afa73918a9fe45c09ef:
> 
>   iwlwifi: mvm: rs: fix compilation without CONFIG_MAC80211_DEBUGFS
> (2013-12-09 22:29:49 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
> for-john
> 
> for you to fetch changes up to cf4ef65446443eb485afe9419ea82b2efbe582a7:
> 
>   iwlwifi: mvm: rs: fix variable shadowing (2013-12-17 22:32:57 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
