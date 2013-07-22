Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53982 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933272Ab3GVUPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 16:15:13 -0400
Date: Mon, 22 Jul 2013 16:02:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-fixes 2013-07-22
Message-ID: <20130722200231.GB29803@tuxdriver.com> (sfid-20130722_221520_902329_4B1A4CF5)
References: <1374494473.14517.8.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1374494473.14517.8.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 22, 2013 at 02:01:13PM +0200, Johannes Berg wrote:
> John,
> 
> And another one for iwlwifi.
> 
> Here I have a fix for debugfs directory creation (causing a spurious
> error message), two scanning fixes from David Spinadel, an LED fix and
> two patches related to a BA session problem that eventually caused
> firmware crashes from Emmanuel and a small BT fix for older devices as
> well as a workaround for a firmware problem with APs with very small
> beacon intervals from myself.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:
> 
>   Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to a590ad411891de551e6de1b51ea635c0484148d6:
> 
>   iwlwifi: mvm: remove extra SSID from probe request (2013-07-16 13:55:15 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
