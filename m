Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58772 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaBXUPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 15:15:14 -0500
Date: Mon, 24 Feb 2014 15:06:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2014-02-23
Message-ID: <20140224200606.GI24810@tuxdriver.com> (sfid-20140224_211545_457465_08990C32)
References: <530A51A4.6000007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 23, 2014 at 09:53:08PM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> Here is pull request intended for 3.15.
> 
> I have here a whole bunch of various things. Trivial cleanups, debugfs handlers and new stuff for the new generation of devices along with new capabilities for monitor mode. We also have support for power save for dual interface mode, but that is not supported by the firmware currently available.
> 
> I had to merge wireless-next to get the new bits for monitor mode I added in mac80211-next.git.
> 
> Let me know if you have any issue.
> Thanks!
> 
> The following changes since commit e57f1734d87aa0e9a00905ed08888f0c62f56227:
> Starting
>   mwifiex: add key material v2 support (2014-02-12 15:36:26 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to 82b715c211a53e80a1db83b9b71995a05fe32908:
> 
>   iwlwifi: mvm: fix a few wd_disable comments (2014-02-23 21:38:54 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
