Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:48083 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbYJ0JFF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 05:05:05 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KuO22-0003ou-Ol
	for linux-wireless@vger.kernel.org; Mon, 27 Oct 2008 09:05:03 +0000
Received: from 221.221.233.227 ([221.221.233.227])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2008 09:05:02 +0000
Received: from eeuix by 221.221.233.227 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2008 09:05:02 +0000
To: linux-wireless@vger.kernel.org
From: JUN <eeuix@yahoo.com>
Subject: Re: Release of Atheros 802.11abg HAL under the ISC
Date: Fri, 24 Oct 2008 02:26:22 +0000 (UTC)
Message-ID: <loom.20081024T022046-734@post.gmane.org> (sfid-20081027_100513_733611_AD92CBED)
References: <20080926215701.GC5972@tesla>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <lrodriguez@...> writes:

> 
> As part of our commitment to help support all of our Atheros devices
> under Linux we'd like to announce the release of our Atheros HAL for
> our 802.11abg chipsets under the ISC license.
> 
> You can find it here:
> 
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/legacy-hal.tar.bz2
> 
> This can be used as a source of documentation to help ath5k move
> forward to support our 802.11abg chipsets as best as possible in
> the Linux kernel. We look forward to keep working strongly with the
> community on advancing support of all our Atheros chipsets under Linux.
> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Thanks for your great job

would you tell me which version of the madwifi you tested
with the HAL source, and work? I've tried with madwifi-0.9.3.1 and simply
replaced the xscale-be-elf.hal.o.uu with the new one. 
madwifi-0.9.3.1 use HAL 0.9.18 by default, and the HAL from 
your source is 0.9.17.1.




