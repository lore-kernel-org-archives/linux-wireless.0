Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:35832 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbeBDUDx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Feb 2018 15:03:53 -0500
Received: by mail-ot0-f195.google.com with SMTP id a2so13729883otf.2
        for <linux-wireless@vger.kernel.org>; Sun, 04 Feb 2018 12:03:52 -0800 (PST)
Subject: Re: Fw: Regression: bcm4312 lp-phy device not recognized in 4.15
 kernel
To: Chris Vine <vine35792468@gmail.com>, b43-dev@lists.infradead.org,
        linux-wireless@vger.kernel.org
References: <20180204185855.74e6ade5@bother.homenet>
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <935a4987-c481-f4e4-16d7-f5f56adcfee0@gmail.com> (sfid-20180204_210357_290006_36F8803E)
Date: Sun, 4 Feb 2018 12:03:49 -0800
MIME-Version: 1.0
In-Reply-To: <20180204185855.74e6ade5@bother.homenet>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/04/2018 10:58 AM, Chris Vine wrote:
> I probably should have copied this to the relevant kernel wireless
> mailing lists.  Anyway, here it is.
> 
> As a further datum point, the b43 driver works fine with the 4.15.0-rc3
> kernel.  So something seems to have changed between that and 4.15.0.

Does this patch help?

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=a9e6d44ddeccd3522670e641f1ed9b068e746ff7

> 
> Chris
> 
> Begin forwarded message:
> 
> Date: Mon, 29 Jan 2018 23:37:49 +0000
> From: Chris Vine <vine35792468@gmail.com>
> To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Subject: Regression: bcm4312 lp-phy device not recognized in 4.15 kernel
> 
> 
> I have an old netbook with a Broadcom bcm4312 802.11b/g lp-phy
> [14e4:4315] (rev 01) wifi device.  It is no longer recognized in kernel
> 4.15: it works fine with the 4.14 kernel and earlier, with the b43 and
> ssb kernel modules.
> 
> I cannot give any further information as there are no error messages
> logged. The b43 firmware (wl-5.100.138) is not loaded for it, nor are
> the ssb/b43/bcma/ mmc_core/mac80211/cfg80211 modules.  The modules can
> be loaded by hand without error, but nothing happens and no network
> interface is presented.
> 
> This is a pretty slow and rubbish netbook but is useful when travelling
> to a country which might impound your laptop (no names) and you don't
> mind too much losing it.  It would be nice to continue to be able to
> use it for that.
> 
> Chris
> 

-- 
Florian
