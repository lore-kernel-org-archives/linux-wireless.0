Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41968 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbbJUHyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 03:54:21 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/1] New driver: rtl8xxxu (mac80211)
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1444869891-21174-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Message-Id: <20151021075420.9891D141078@smtp.codeaurora.org> (sfid-20151021_095424_112978_1FDE2EF2)
Date: Wed, 21 Oct 2015 07:54:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> This is an alternate driver for a number of Realtek WiFi USB devices,
> including RTL8723AU, RTL8188CU, RTL8188RU, RTL8191CU, and RTL8192CU.
> It was written from scratch utilizing the Linux mac80211 stack.
> 
> After spending months cleaning up the vendor provided rtl8723au
> driver, which comes with it's own 802.11 stack included, I decided to
> rewrite this driver from the bottom up.
> 
> Many thanks to Johannes Berg for 802.11 insights and help and Larry
> Finger for help with the vendor driver.
> 
> The full git log for the development of this driver can be found here:
> git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git
>     branch rtl8723au-mac80211
> 
> This driver is still under development, but has proven to be very
> stable for me. It currently supports station mode only. It has support
> for OFDM and CCK rates. It does lack certain features found in the
> staging driver, such as power management, AMPDU, and 40MHz channel
> support. In addition it does not support AD-HOC, AP, and monitor mode
> support at this point.
> 
> The driver is known to work with the following devices:
> Lenovo Yoga (rtl8723au)
> TP-Link TL-WN823N (rtl8192cu)
> Etekcity 6R (rtl8188cu)
> Daffodil LAN03 (rtl8188cu)
> Alfa AWUS036NHR (rtl8188ru)
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
