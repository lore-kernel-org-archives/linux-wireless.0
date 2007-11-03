Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:44569 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbXKCSej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Nov 2007 14:34:39 -0400
Date: Sat, 3 Nov 2007 19:34:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: iwl3945 in 2.6.24-rc1 dies under load
Message-ID: <20071103183446.GD13202@elf.ucw.cz> (sfid-20071103_183443_635983_9EBA532F)
References: <20071031005202.GA1534@elf.ucw.cz> <1193792098.9704.16.camel@debian.sh.intel.com> <20071101001221.GA1755@elf.ucw.cz> <1193881026.31257.52.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1193881026.31257.52.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> > iwl3945: 0000000000     0x0000007b      403761122
> > iwl3945: 0000000002     0x0000007d      403761129
> > iwl3945: I iwl_irq_handle_error Restarting adapter due to uCode error.
> > iwl3945: Error Reply type 0x00000005 cmd REPLY_TX (0x1C) seq 0x0203
> > ser 0x0000004B
> > iwl3945: Can't stop Rx DMA.
> > wlan0: No ProbeResp from current AP 00:11:2f:0e:95:a0 - assume out of
> > range
> 
> This firmware error dump is useful. Thanks!

Good.

BTW... the wireless light does not seem to work on x60. It used to
work with some -mm versions...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
