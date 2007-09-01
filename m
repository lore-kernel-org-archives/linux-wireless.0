Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2250 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbXIANox (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 09:44:53 -0400
Date: Sat, 1 Sep 2007 09:12:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	yi.zhu@intel.com
Subject: Re: borkage in 2.6.23-rc4-mm1
Message-ID: <20070901131248.GA4462@tuxdriver.com>
References: <20070831211603.083dfed2.akpm@linux-foundation.org> <46D9352B.4060606@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46D9352B.4060606@garzik.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 01, 2007 at 05:47:23AM -0400, Jeff Garzik wrote:
> Andrew Morton wrote:
> >Aug 31 20:58:07 sony kernel: ipw2200: Firmware error detected.  Restarting.

> I see this on my Sony Vaio with older, non-mm kernels too.  Incredibly 
> frustrating, as it seems to be related to the phase of the moon. 
> Sometimes a reboot gets my wireless working, sometimes it doesn't.

There have been a few random reports of firmware restarts with ipw2x00
for a long time.  Unfortunately, only Intel has any visibility into
that firmware.  Do make sure you have the latest firmware released
from Intel (you probably do already, but it's worth checking).

Yi, any thoughts?

John
-- 
John W. Linville
linville@tuxdriver.com
