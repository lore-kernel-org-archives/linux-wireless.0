Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57172 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab3GaTaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 15:30:09 -0400
Date: Wed, 31 Jul 2013 15:15:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@ml01.01.org>
Subject: Re: [GIT] [NFC] 3.11 fixes
Message-ID: <20130731191551.GF2311@tuxdriver.com> (sfid-20130731_213014_697204_8BD838DA)
References: <20130730235915.GA4641@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130730235915.GA4641@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 31, 2013 at 01:59:15AM +0200, Samuel Ortiz wrote:
> Hi John,
> 
> This is the second NFC fixes pull request for 3.11.
> 
> We have:
> 
> 1) A build failure fix for the NCI SPI transport layer due to a
>    missing CRC_CCITT Kconfig dependency.
> 
> 2) A netlink command rename: CMD_FW_UPLOAD was merged during the 3.11
>    merge window but the typical terminology for loading a firmware to a
>    target is firmware download rather than upload. In order to avoid any
>    confusion in a file exported to userspace, we rename this command to
>    CMD_FW_DOWNLOAD.
> 
> I realize 2) might not meet the net.git criteria for what fixes are. If
> you don't want to take it then I'll have to push it through the
> 3.12 merge window. If that's the case, and you only want to take 1) then
> please use tags/nfc-3.11-1 instead of tags/nfc-3.11-2 in your pull URL.
> 
> The following changes since commit 64b6f46f1141ad938e354f37af62e28da972e8eb:
> 
>   ath9k_hw: Fix multicast search for AR9002 family (2013-07-18 16:22:00 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.11-2
> 
> for you to fetch changes up to 9ea7187c53f63e31f2d1b2b1e474e31808565009:
> 
>   NFC: netlink: Rename CMD_FW_UPLOAD to CMD_FW_DOWNLOAD (2013-07-31 01:19:43 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
