Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49783 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaKKVPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 16:15:11 -0500
Date: Tue, 11 Nov 2014 16:11:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: pull request: iwlwifi 2014-11-10
Message-ID: <20141111211134.GE6780@tuxdriver.com> (sfid-20141111_221516_336065_A4A296EC)
References: <CANUX_P2Q31DLtiZJ-GNcnME3LDXE2vWLN61QqNOxsjqxgfb4Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P2Q31DLtiZJ-GNcnME3LDXE2vWLN61QqNOxsjqxgfb4Gg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 10, 2014 at 09:37:16PM -0800, Emmanuel Grumbach wrote:
> Hi John,
> 
> This is a pull request for 3.18. More details below.
> Please pull - thanks!
> 
> The following changes since commit 31b8b343e019e0a0c57ca9c13520a87f9cab884b:
> 
>   iwlwifi: fix RFkill while calibrating (2014-11-03 15:29:17 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
> tags/iwlwifi-for-john-2014-11-10
> 
> for you to fetch changes up to 87dd634ae72bb8f6d0dd12f1cbbc67c7da6dba3b:
> 
>   iwlwifi: pcie: fix prph dump length (2014-11-11 07:24:57 +0200)
> 
> ----------------------------------------------------------------
> Two fixes here - we weren't updating mac80211 if a scan
> was cut short by RFKILL which confused cfg80211. As a
> result, the latter wouldn't allow to run another scan.
> Liad fixes a small bug in the firmware dump.
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       iwlwifi: mvm: abort scan upon RFKILL
> 
> Liad Kaufman (1):
>       iwlwifi: pcie: fix prph dump length

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
