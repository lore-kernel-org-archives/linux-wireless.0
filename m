Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34617 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbcA2QNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 11:13:38 -0500
Received: by mail-pf0-f173.google.com with SMTP id o185so39602799pfb.1
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jan 2016 08:13:38 -0800 (PST)
Date: Fri, 29 Jan 2016 21:43:26 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: ksenija.stanojevic@gmail.com,
	"driverdev-devel@linuxdriverproject.org"
	<driverdev-devel@linuxdriverproject.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Move wlan-ng out of staging?
Message-ID: <20160129161326.GA15484@sudip-laptop> (sfid-20160129_171341_120602_9762212C)
References: <56AB8C90.2050909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56AB8C90.2050909@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 29, 2016 at 05:00:16PM +0100, Xose Vazquez Perez wrote:
> Ksenija wrote:
> 
> > I'm helping Greg do a bit of cleanup in the staging tree, I noticed that
> > wlan-ng driver is maybe ready to be moved out of staging. Are there
> > any TODO tasks left to do beside checkpatch.pl clean-up?
> 
> Its FAQ was very clear: ftp://ftp.linux-wlan.org/pub/linux-wlan-ng/FAQ
> [archived at http://puppylinux.dreamhosters.com/wireless/linux-wlan-org_FAQ.txt ]
> 
> --cut--
> Q: When will linux-wlan-ng be merged into the mainline kernel?
> 
> 	Short answer:  Never.

The ultimate aim of a driver in staging is to graduate out of staging
area into the main part of the kernel. If it is already known that this
driver can never move out of staging then IMHO its better to remove it.

regards
sudip
