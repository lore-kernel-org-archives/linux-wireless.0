Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55108 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbIFOnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2015 10:43:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH v2 0/1] rtl8xxxu (mac80211) driver for rtl8188[cr]u/rtl8192cu/rtl8723au
References: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com>
Date: Sun, 06 Sep 2015 17:43:39 +0300
In-Reply-To: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com> (Jes
	Sorensen's message of "Sun, 30 Aug 2015 17:02:53 -0400")
Message-ID: <87y4gjfw10.fsf@kamboji.qca.qualcomm.com> (sfid-20150906_164351_179921_FF87DFF8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes.Sorensen@redhat.com writes:

> Per default only devices I have actually tested will be enabled. If
> you are interested in trying it out with other 8188cu/8188ru/819[12]cu
> dongles, you need to enable CONFIG_RTL8XXXU_UNTESTED. Please report
> test results back to me.
>
> Note if you enable this driver, it may clash with CONFIG_RTL8192U,
> CONFIG_R8723AU, and CONFIG_RTL8192CU (rtlwifi). Please pay attention
> to which module you load and/or use modprobe blacklists.

May clash? So how does this work in practise? Is the clash referring
CONFIG_RTL8XXXU_UNTESTED enabled or disabled?

I think we should only have one driver automatically supporting certain
hardware, and not have a driver randomly chosen and forcing users to use
a blacklist.

Also how do we make sure that distros don't enable
CONFIG_RTL8XXXU_UNTESTED? They are notarious of enabling kconfig options
without thinking.

-- 
Kalle Valo
