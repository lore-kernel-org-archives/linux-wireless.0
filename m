Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39705 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaKXTAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 14:00:13 -0500
Date: Mon, 24 Nov 2014 13:55:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: pull request: iwlwifi 2014-11-23
Message-ID: <20141124185524.GC12375@tuxdriver.com> (sfid-20141124_200017_745520_B4A477D2)
References: <54723BE7.6040607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54723BE7.6040607@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 23, 2014 at 09:56:23PM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> I have a trivial patch for 3.18. details below.
> Thanks!
> 
> The following changes since commit 87dd634ae72bb8f6d0dd12f1cbbc67c7da6dba3b:
> 
>   iwlwifi: pcie: fix prph dump length (2014-11-11 07:24:57 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-john-2014-11-23
> 
> for you to fetch changes up to 5ac6c72e594471acfa5b00210c51d533a73413ad:
> 
>   iwlwifi: mvm: check TLV flag before trying to use hotspot firmware commands (2014-11-23 21:50:57 +0200)
> 
> ----------------------------------------------------------------
> Not all the firmware know how to handle the HOT_SPOT_CMD.
> Make sure that the firmware will know this command before
> sending it. This avoids a firmware crash.

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
