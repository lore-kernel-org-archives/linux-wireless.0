Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52816 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3G2TAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 15:00:11 -0400
Date: Mon, 29 Jul 2013 14:45:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-fixes 2013-07-26
Message-ID: <20130729184551.GF31172@tuxdriver.com> (sfid-20130729_210016_245530_4A934B4F)
References: <1374826675.8248.11.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1374826675.8248.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 26, 2013 at 10:17:55AM +0200, Johannes Berg wrote:
> John,
> 
> Yet some more fixes - we're adding tests and are doing a debug cycle
> with them.
> 
> We have a scan fix for passive channels, a new PCI device ID for an old
> device, a NIC reset fix, an RF-Kill fix, a fix for powersave when GO
> interfaces are present as well as an aggregation session fix (for a
> corner case) and a workaround for a firmware design issue - it only
> supports a single GTK in D3.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> 
> 
> The following changes since commit a590ad411891de551e6de1b51ea635c0484148d6:
> 
>   iwlwifi: mvm: remove extra SSID from probe request (2013-07-16 13:55:15 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to a53ee0a308b16e392e0219c585b10f329345766b:
> 
>   iwlwifi: pcie: clear RFKILL interrupt in AMPG (2013-07-26 10:07:10 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
