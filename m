Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47035 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3JGRaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 13:30:14 -0400
Date: Mon, 7 Oct 2013 13:26:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-fixes 2013-10-02
Message-ID: <20131007172658.GB1821@tuxdriver.com> (sfid-20131007_193017_768723_D8506D35)
References: <1380729859.13329.23.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380729859.13329.23.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 02, 2013 at 06:04:19PM +0200, Johannes Berg wrote:
> John,
> 
> Here are a few fixes for iwlwifi.
> 
> I have a fix for WoWLAN/D3, a PCIe device fix, we're removing a warning,
> there's a fix for RF-kill while scanning (which goes together with a
> mac80211 fix) and last but not least we have many new PCI IDs.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> 
> The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:
> 
>   Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to 5a3e9f7f8c8768b5f7df81100c684e4cd00a6eb5:
> 
>   iwlwifi: mvm: call ieee80211_scan_completed when needed (2013-10-02 11:25:50 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
