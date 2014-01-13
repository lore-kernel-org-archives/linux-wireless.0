Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56348 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaAMTpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 14:45:14 -0500
Date: Mon, 13 Jan 2014 14:39:20 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux NFC <linux-nfc@ml01.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [GIT] [3.14] NFC update
Message-ID: <20140113193920.GC14400@tuxdriver.com> (sfid-20140113_204520_212108_AE2A4920)
References: <20140109231546.GA11700@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140109231546.GA11700@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 10, 2014 at 12:15:46AM +0100, Samuel Ortiz wrote:
> Hi John,
> 
> This is the first NFC pull request for 3.14
> 
> It includes:
> 
> * A new NFC driver for Marvell's 8897, and a few NCI fixes and
>   improvements needed to support this chipset.
> 
> * An LLCP fix for how we were setting the default MIU on a p2p link. If
>   there is no explicit MIU extension announced at connection time, we
>   must use the default one and not the one announced at LLCP link
>   establishement time.
> 
> * A pn544 EEPROM config update. Some of the currently EEPROM configured
>   values are overwriting the firmware ones while other should not be set
>   by the driver itself.
> 
> * Some NFC digital stack fixes and improvements. Asynchronous functions
>   are better documented, RF technologies and CRC functions are set upon
>   PSL_REQ reception, and a few minor bugs are fixed.
> 
> * Minor and miscelaneous pn533, mei_phy and port100 fixes.
> 
> Thanks in advance for pulling those bits in.
> 
> The following changes since commit c8bf40ad4f8f5d26f6744020ad51be420a707385:
> 
>   wireless: delete non-required instances of include <linux/init.h> (2014-01-03 15:37:01 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.14-1
> 
> for you to fetch changes up to bb55dc2ae4367b8f711d43a2f8668a6ed42c4fd3:
> 
>   NFC: nfcmrvl: Fix possible memory leak issue (2014-01-09 01:27:20 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
