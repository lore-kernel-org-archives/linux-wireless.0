Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4744 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbXLWCXm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 21:23:42 -0500
Date: Sat, 22 Dec 2007 21:23:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Shawn Tan <ssnt2@eng.cam.ac.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: B43 not working
Message-ID: <20071223022326.GA13785@tuxdriver.com> (sfid-20071223_022344_689238_F8BE5EEA)
References: <200712230117.35920.ssnt2@eng.cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200712230117.35920.ssnt2@eng.cam.ac.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 23, 2007 at 01:17:35AM +0000, Shawn Tan wrote:
> Hi,
> 
> B43 still doesn't work for me. Let me know if any additional information from 
> me will help.
> 
> dmesg:
> 
> [40699.800000] PCI: Setting latency timer of device 0000:30:00.0 to 64
> [40699.840000] ssb: SPROM revision 3 detected.
> [40699.860000] ssb: Sonics Silicon Backplane found on PCI device 0000:30:00.0
> [40699.876000] b43-phy0: Broadcom 4311 WLAN found
> [40700.044000] phy0: Failed to select rate control algorithm
> [40700.044000] phy0: Failed to initialize rate control algorithm
> [40700.080000] b43: probe of ssb0:0 failed with error -2

You must be using an old tree.  'modprobe rc80211_simple' or use the
'everything' branch of a recent (last month or so) wireless-2.6.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
