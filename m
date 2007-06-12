Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:46591 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752472AbXFLLvg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 07:51:36 -0400
Date: Tue, 12 Jun 2007 13:51:34 +0200
From: Jiri Benc <jbenc@suse.cz>
To: zergavis <zergavis@o2.pl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi - not compatible with xorg 7.1 and i810 ??
Message-ID: <20070612135134.17d3c039@logostar.upir.cz>
In-Reply-To: <93387350.20070610005957@o2.pl>
References: <93387350.20070610005957@o2.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 10 Jun 2007 00:59:57 +0200, zergavis wrote:
> It's sounds silly, but new iwlwifi-0.0.25 crash down Xorg server. The
> problem is intel i810 video driver.
> 
> In my toshiba A200 I've got intel945GM pci-e video card. It run
> normal on xf-video-i810 driver (kernel support of 945 is experimental)
> on archlinux.
> 
> When I install iwlwifi-0.0.25 (make, make install) for 4965AGN and
> restart xserver, it crash...
> 
> Error log:
> 
> (EE) I810(0): V_BIOS Address 0x80 out of range
> (EE) I810(0): VBE initialization failed.
> (EE) Screen(s) found, but none have a usable configuration.

I hit this too on two different cards, without iwlwifi driver. Unlike you,
the only solution that worked for me was restart.

Seems like a bug in i810. It's possible it's triggered by loading iwlwifi
or it may be just a coincidence.

Does restart (I really mean a full reboot, to let BIOS reinitialize the
card) fix the problem with iwlwifi still installed?

 Jiri

-- 
Jiri Benc
SUSE Labs
