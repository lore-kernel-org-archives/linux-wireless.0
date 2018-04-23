Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:42263 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754786AbeDWNQN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 09:16:13 -0400
Date: Mon, 23 Apr 2018 16:16:09 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: Ayala Beker <ayala.beker@intel.com>, linux-wireless@vger.kernel.org
Subject: Re: [BUG] iwlwifi: Microcode SW error detected.  Restarting
 0x2000000.
Message-ID: <20180423131609.GT2173@lahna.fi.intel.com> (sfid-20180423_151616_914057_8707857B)
References: <20180423120513.GS2173@lahna.fi.intel.com>
 <2769dd4501a9132f638202fece264de32218860d.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2769dd4501a9132f638202fece264de32218860d.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 23, 2018 at 03:39:45PM +0300, Luciano Coelho wrote:
> We had a bug in the scan command size for older firmwares.  I have
> already made a fix for it, but I hadn't sent it out for upstream yet. 
> I'll send it out now and soon send you a link to it in patchwork.
> 
> You have two options: recompile the kernel with my patch or; use the
> latest version of the firmware from linux-firmware.git[1].
> 
> I recommend upgrading the firmware, because we have a lot of other
> fixes and improvements there, but if you want to keep your distro's
> original firmware package, you can apply my patch instead.
> 
> HTH and thanks for reporting!

I upgraded the firmware to iwlwifi-8265-36.ucode and the issue is gone
now. Thanks Luca!
