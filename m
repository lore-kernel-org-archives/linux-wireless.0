Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38189 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146Ab3DJRqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 13:46:06 -0400
Date: Wed, 10 Apr 2013 13:32:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2013-04-08
Message-ID: <20130410173222.GD15428@tuxdriver.com> (sfid-20130410_194612_053200_FAE1A5D3)
References: <1365421282.25475.11.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365421282.25475.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 08, 2013 at 01:41:22PM +0200, Johannes Berg wrote:
> John,
> 
> And also another pull request for iwlwifi-next.
> 
> The biggest work here is Bluetooth coexistence and power saving. Other
> than that, I have a few small fixes that weren't really needed for 3.9
> and a new PCI ID.
> 
> johannes
> 
> 
> The following changes since commit 64513ef449e3beaacb801d41467f47642683e35a:
> 
>   b43: remove warning for LP-PHY with sprom < 8 (2013-03-25 16:47:06 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to 2d055afdcada4bd8b510e9d2a8566fbded3c9696:
> 
>   iwlwifi: dvm: handle FLUSH ampdu actions from mac80211 (2013-04-08 13:32:20 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
