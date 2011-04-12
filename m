Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20759 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067Ab1DLUZ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 16:25:59 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 13:25:34 -0700
Date: Tue, 12 Apr 2011 13:28:53 -0700
From: Vipin Mehta <vmehta@atheros.com>
To: Naveen Singh <nsingh@atheros.cm>
CC: "greg@kroah.com" <greg@kroah.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vipin Mehta <Vipin.Mehta@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Naveen Singh <Naveen.Singh@Atheros.com>
Subject: Re: [PATCH 0/5] staging:ath6kl:patches for supporting 2.1.1 and
 bug fixes
Message-ID: <20110412202853.GA20598@vmehta-desktop>
References: <1302148341-1783-1-git-send-email-nsingh@atheros.cm>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1302148341-1783-1-git-send-email-nsingh@atheros.cm>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 06, 2011 at 08:52:16PM -0700, Naveen Singh wrote:
> From: Naveen Singh <nsingh@atheros.com>
> 
> Greg,
> 
> These are set of 5 patches for ath6kl. These patches are related
> to the correct functionality of driver as well as providing the
> support of 2.1.1 silicon in the upstream driver.
> 
> I have tested each and every patch.With each and every patch I was
> able to compile the kernel, load the kernel, and do a basic connectivity
> test with an external AP.These patches are tested on wireless-testing
> as compared to staging-next because top of staging-next compilation
> was broken. To do this I applied all the patches related to ath6k from 
> staging-next tree to the wireless-testing tree and then I applied these
> patches.
> 
> These should apply cleanly to staging-next tree as well. Let me know if
> you have any issues.
> 
> Naveen Singh (5):
>   staging:at6kl:Support for V2.1.1 Silicon
>   staging:ath6kl: Introduction of new CMD/EVT ID
>   staging:ath6kl:DEV ID in the DATA/CMD Packet
>   staging:ath6kl:Scan operation while disconnect
>   staging:ath6kl:cfg ops for power management
> 
>  drivers/staging/ath6kl/include/common/targaddrs.h  |  224 +++++++++++++++++---
>  drivers/staging/ath6kl/include/common/wmi.h        |  117 +++++++++--
>  drivers/staging/ath6kl/os/linux/ar6000_drv.c       |  125 +++++++++---
>  drivers/staging/ath6kl/os/linux/cfg80211.c         |    8 +-
>  .../staging/ath6kl/os/linux/include/ar6000_drv.h   |   57 +++++-
>  drivers/staging/ath6kl/wmi/wmi.c                   |   23 +--
>  6 files changed, 446 insertions(+), 108 deletions(-)
> 

Greg,
  Did you get a chance to review these patches? Pls provide us your feedback.

Vipin
