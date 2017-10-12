Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swan.media.mit.edu ([18.85.44.157]:53992 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753200AbdJLVZB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 17:25:01 -0400
Date: Fri, 13 Oct 2017 08:24:54 +1100
From: James Cameron <quozl@laptop.org>
To: Mario Theodoridis <mario@schmut.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi crash with hostapd
Message-ID: <20171012212454.GB4362@us.netrek.org> (sfid-20171012_232504_725517_DD3CF558)
References: <6e51916a-6178-5620-8f45-54705c1b4d98@schmut.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6e51916a-6178-5620-8f45-54705c1b4d98@schmut.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 12, 2017 at 10:26:33PM +0200, Mario Theodoridis wrote:
> Hello everyone,
> 
> i'm running Kubuntu 16.04 as a Virtualbox VM host, and a wireless AP
> with an Intel Wireless 7260.
> 
> My WLAN connections frequently keep dying, so that i need to
> disconnect and reconnect in order to use them again.
> My syslog is full of these:
> 
> Oct 12 21:48:55 zippy kernel: [3546600.957321] ------------[ cut here
> ]------------
> Oct 12 21:48:55 zippy kernel: [3546600.957352] WARNING: CPU: 2 PID: 1571 at
> /build/linux-YyUNAI/linux-4.4.0/drivers/net/wireless/iwlwifi/mvm/utils.c:740
> iwl_mvm_disable_txq+0x2a6/0x2c0 [iwlmvm]()
> [...]
> I'm not sure if this is the right forum to post this.
> If it isn't, a pointer to the right place would be appreciated.

This is a right place.  Another right place is Ubuntu bug reporting.

> Please include me in the reply as i'm not on the list.
> Let me know, what additional details i need to provide, as i'm
> interested in getting this to work.

There's a good chance this problem has been fixed already.  You
are using a v4.4 kernel with many patches applied by Ubuntu.  Here, we
are more concerned with the latest kernels, and v4.4 is quite old.

Please test some of the later kernels, see
https://wiki.ubuntu.com/Kernel/MainlineBuilds

In particular, test v4.13 or v4.14-rc4.

If the problem still happens, capture the same information and send it
again as a reply.

If the problem doesn't happen, then you can either continue to use the
new kernel, or find when the problem was fixed; a long but rewarding
process.

Should the problem have been fixed for v4.10, you might also switch to
using the Ubuntu package linux-generic-hwe-16.04.
https://wiki.ubuntu.com/Kernel/RollingLTSEnablementStack#hwe-16.04

Hope that helps.

> Thanks.
> 
> Regards
> 
> Mario

[...]

-- 
James Cameron
http://quozl.netrek.org/
