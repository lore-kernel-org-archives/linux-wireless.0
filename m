Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57634 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaBLUaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 15:30:11 -0500
Date: Wed, 12 Feb 2014 15:27:01 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: pull request: iwlwifi-next 2014-02-03
Message-ID: <20140212202700.GF22203@tuxdriver.com> (sfid-20140212_213019_977732_6C48296D)
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 03, 2014 at 10:56:36PM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> It seems that the team worked hard based on the size of the pull request:)
> Let me know if this is too big, so that I can find the right balance.
> 
> I have here support for D0i3 which is runtime power saving state. This
> work is still on going. Along with that I have implementation of
> broadcast filtering by Eliad. I provide the usual amount of clean ups
> etc... Note that we begin to warn users that are still using the old
> firmware but we still support it in 3.15. I will remove support for this
> old firmware in 3.16.
> Eran begins to add support for next-gen devices while Johannes
> implemented uAPSD for AP / GO along with other various things.
> Ilan is tuning the quota allocation and Ido Yariv contributes a new
> feature that allows to limit the power we consume based on entries in
> ACPI tables.
> 
> Here again, let me know of issues if any!
> 
> The following changes since commit 9b0cd304f26b9fca140de15deeac2bf357d1f388:
> 
>   Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
> (2014-01-29 20:49:12 -0800)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
> for-john
> 
> for you to fetch changes up to 8e305d171ab58dbd79ad8e13d93db2237fde5749:
> 
>   iwlwifi: mvm: remove duplicate assignment to ap_ibss_active
> (2014-02-03 22:43:53 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
