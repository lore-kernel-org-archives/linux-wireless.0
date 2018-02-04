Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:42830 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbeBDWAg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Feb 2018 17:00:36 -0500
Received: by mail-wr0-f195.google.com with SMTP id 41so26339704wrc.9
        for <linux-wireless@vger.kernel.org>; Sun, 04 Feb 2018 14:00:35 -0800 (PST)
Date: Sun, 4 Feb 2018 22:00:32 +0000
From: Chris Vine <vine35792468@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: Regression: bcm4312 lp-phy device not recognized in 4.15 kernel
Message-ID: <20180204220032.3c339324@bother.homenet> (sfid-20180204_230056_575499_2EDD9ECC)
In-Reply-To: <935a4987-c481-f4e4-16d7-f5f56adcfee0@gmail.com>
References: <20180204185855.74e6ade5@bother.homenet>
        <935a4987-c481-f4e4-16d7-f5f56adcfee0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 4 Feb 2018 12:03:49 -0800
Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 02/04/2018 10:58 AM, Chris Vine wrote:
> > I probably should have copied this to the relevant kernel wireless
> > mailing lists.  Anyway, here it is.
> > 
> > As a further datum point, the b43 driver works fine with the
> > 4.15.0-rc3 kernel.  So something seems to have changed between that
> > and 4.15.0.
> 
> Does this patch help?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=a9e6d44ddeccd3522670e641f1ed9b068e746ff7

Yes, I have wireless working again.

I'll recompile tomorrow from a fresh kernel tree and apply the patch
again and make sure it still works.  I will let you know.

-----------------------------------------
> > 
> > Begin forwarded message:
> > 
> > Date: Mon, 29 Jan 2018 23:37:49 +0000
> > From: Chris Vine <vine35792468@gmail.com>
> > To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> > Subject: Regression: bcm4312 lp-phy device not recognized in 4.15
> > kernel
> > 
> > 
> > I have an old netbook with a Broadcom bcm4312 802.11b/g lp-phy
> > [14e4:4315] (rev 01) wifi device.  It is no longer recognized in
> > kernel 4.15: it works fine with the 4.14 kernel and earlier, with
> > the b43 and ssb kernel modules.
> > 
> > I cannot give any further information as there are no error messages
> > logged. The b43 firmware (wl-5.100.138) is not loaded for it, nor
> > are the ssb/b43/bcma/ mmc_core/mac80211/cfg80211 modules.  The
> > modules can be loaded by hand without error, but nothing happens
> > and no network interface is presented.
> > 
> > This is a pretty slow and rubbish netbook but is useful when
> > travelling to a country which might impound your laptop (no names)
> > and you don't mind too much losing it.  It would be nice to
> > continue to be able to use it for that.
> > 
> > Chris
> > 
