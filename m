Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57880 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759349Ab3DATav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 15:30:51 -0400
Date: Mon, 1 Apr 2013 15:15:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux NFC <linux-nfc@ml01.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [GIT] [3.9] NFC fixes
Message-ID: <20130401191550.GC3526@tuxdriver.com> (sfid-20130401_213102_112508_CA620F5D)
References: <20130331232610.GQ2153@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130331232610.GQ2153@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 01, 2013 at 01:26:10AM +0200, Samuel Ortiz wrote:
> Hi John,
> 
> This is the 2nd batch of NFC fixes for 3.9. This time we have:
> 
> - A crash fix for when a DGRAM LLCP socket is listening while the NFC adapter
>   is physically removed.
> - A potential double skb free when the LLCP socket receive queue is full.
> - A fix for properly handling multiple and consecutive LLCP connections, and
>   not trash the socket ack log.
> - A build failure for the MEI microread physical layer, now that the MEI bus
>   APIs have been merged into char-misc-next.
> 
> The following changes since commit 36ef0b473fbf43d5db23eea4616cc1d18cec245f:
> 
>   rtlwifi: usb: add missing freeing of skbuff (2013-03-18 15:20:38 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.9-2
> 
> for you to fetch changes up to 9593b0b1179c526436f14849a9587fd2aae12040:
> 
>   NFC: microread: Fix build failure due to a new MEI bus API (2013-04-01 00:52:42 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
